FROM tomcat:9.0-jdk11

# Copy the WAR file to the Tomcat webapps directory as ROOT.war
COPY target/petclinic.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
