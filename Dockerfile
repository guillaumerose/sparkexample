FROM maven:3.5-jdk-8-alpine

WORKDIR /code

# Prepare by downloading dependencies
ADD pom.xml /code/pom.xml
RUN ["mvn", "dependency:resolve"]
RUN ["mvn", "verify"]

# Adding source, compile and package into a fat jar
ADD src /code/src
RUN ["mvn", "package"]

FROM openjdk:8-jre-alpine
COPY --from=0 /code/target/sparkexample-jar-with-dependencies.jar .
EXPOSE 4567
CMD ["java", "-jar", "sparkexample-jar-with-dependencies.jar"]
