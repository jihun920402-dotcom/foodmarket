
FROM tomcat:9.0-jdk21-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ./src/main/webapp/ /usr/local/tomcat/webapps/ROOT/

COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]