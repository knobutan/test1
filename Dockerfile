FROM openjdk:11-jdk-slim
COPY DockerTest-0.0.1-SNAPSHOT.jar springdoc.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/springdoc.jar"]  
