# Testing Code Engine

Prerequisites:
- IBM Cloud Code Engine (CE)
- Container registry (CR) access 
- API key that can store CR

Understanding how CE works.

Step 1. Create a Dockerfile. An definition of docker image to deploy on CE.
In this git, I do already have a SpringBoot app in jar. Dockerfile in this demo is super simple, it just runs the jar.
FROM openjdk:11-jdk-slim
COPY DockerTest-0.0.1-SNAPSHOT.jar springdoc.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/springdoc.jar"]  

Step 2. build kicks in when you specifies this repo via CE. Repository and IBM Cloud CR detail are inherited from the UI.
It builds a docker image using Dockerfile in curent dir then pushes to CR.
set -ex
export REPOSITORY=${REPOSITORY:-ibmcom}

Build the image
docker build -t ${REPOSITORY}/sbdocker .

And push it
docker push ${REPOSITORY}/sbdocker

SStep 3. Once build is done then run kicks in. Essentially by this line.
ibmcloud ce app create -n sbdocker --image ${REPOSITORY}/sbdocker
