
pipeline {
    agent any 
    
    tools {
        jdk 'jdk17' 
        maven 'maven3'
    }
    
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    parameters {
        // Active Choice parameter with 3 scan options
        choice(
            name: 'SCAN_TYPE',
            choices: ['Baseline', 'API', 'FULL'],
            description: 'Select the type of ZAP scan you want to run.'
        )
    }
    
    stages {
        
        stage("Git Checkout") {
            steps {
                echo "checked out decleratively"
            }
        }
        
        stage("Compile") {
            steps {
                sh "mvn clean compile"
            }
        }
        
        stage("Test Cases") {
            steps {
                sh "mvn test"
            }
        }
        
        stage("Sonarqube Analysis") {
            steps {
                withSonarQubeEnv('sonar-scanner') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=maven \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=maven'''
                }
            }
        }
        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format HTML ', odcInstallation: 'dp'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('Lint Dockerfile') {
            steps {
                // Step 1: Lint the Dockerfile using Hadolint
                script {
                    // Run Hadolint Docker image and save output to a text file
                    sh 'docker run --rm -i hadolint/hadolint < Dockerfile > hadolint_report.txt'
                }
            }
        }
        stage('Docker Image Vulnerability Scanning') {
            steps {
                script {
                    // Run Trivy to scan the 'hello-world' Docker image for vulnerabilities
                    sh '''
                    docker pull hello-world
                    docker run --rm -v $(pwd):/root/.cache/ aquasec/trivy image --severity HIGH,CRITICAL --format table hello-world > trivy_test_report.txt
                    '''
                    
                    // Archive the generated text file for reviewing the test report
                    archiveArtifacts artifacts: 'trivy_test_report.txt', allowEmptyArchive: false
                }
            }
        }
        
        stage("Build") {
            steps {
                sh "mvn clean install"
            }
        }
    }
}
