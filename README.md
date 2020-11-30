# Testing Code Engine

1. Dockerfile is super simple. It runs simple image and runs its jar file.
FROM openjdk:11-jdk-slim
COPY target/DockerTest-0.0.1-SNAPSHOT.jar springdoc.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/springdoc.jar"]  

2. I believe `build` kicks in when you specifies this repo via CE. Repository and IBM Cloud CR detail are inherited from the UI. (Or env var?)
It builds a docker image using Dockerfile in curent dir then pushes to CR.
set -ex
export REPOSITORY=${REPOSITORY:-ibmcom}
# Build the image
docker build -t ${REPOSITORY}/sbdocker .
# And push it
docker push ${REPOSITORY}/sbdocker

3. Once build is done then `run` kicks in. Essentially by this line.
ibmcloud ce app create -n sbdocker --image ${REPOSITORY}/sbdocker

