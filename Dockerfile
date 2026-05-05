# Step 1: Base Image (Tomcat with Java 11)
FROM tomcat:9.0-jdk11

# Step 2: Maintainer Info
LABEL maintainer="MithunTechnologies"

# Step 3: Deployment context clear cheyyadaniki default apps ni remove cheyyochu (Optional but recommended)
# RUN rm -rf /usr/local/tomcat/webapps/*

# Step 4: Mee war file ni Tomcat webapps folder loki copy cheyyadam
# Note: Ikkada file name 'maven-web-application.war' ga unte application URL: http://<IP>:8080/maven-web-application/ lo access avtundi
COPY target/maven-web-application.war /usr/local/tomcat/webapps/maven-web-application.war

# Step 5: Port 8080 expose cheyyadam
EXPOSE 8080

# Step 6: Tomcat ni start chese command (Base image lo idi default ga untundi, kani rasi unchadam best practice)
CMD ["catalina.sh", "run"]

