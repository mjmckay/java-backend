#Download image from artifactory
ARG REGISTRY
ARG APIKEY
FROM openjdk:11-jdk
#FROM $REGISTRY/openjdk:11-jdk

WORKDIR /app

#Define ARG Again -ARG variables declared before the first FROM need to be declered again
ARG REGISTRY
ARG APIKEY
MAINTAINER Elad Hirsch

# Download artifacts from Artifactory
RUN curl -L --output server.jar https://mjmckay.jfrog.io/artifactory/demo-mvn-virtual/com/jfrog/backend/1.0.0/backend-1.0.0.jar
RUN curl -L --output client.tgz http://mjmckay.jfrog.io/artifactory/demo-npm-virtual/frontend/-/frontend-3.0.0.tgz

#Extract vue app
RUN tar -xzf client.tgz && rm client.tgz

# Set JAVA OPTS + Static file location
ENV STATIC_FILE_LOCATION="/app/package/target/dist/"
# ENV GO_SERVICE="127.0.0.1"
ENV JAVA_OPTS=""

# Fire up our Spring Boot app
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Dspring.profiles.active=remote -Djava.security.egd=file:/dev/./urandom -jar /app/server.jar" ]
