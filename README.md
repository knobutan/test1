# Testing Code Engine

Prerequisites:
- IBM Cloud Code Engine (CE)
- Container registry (CR) access 
- API key that can store CR

Understanding how CE works. 2 and 3 will be executed in the background when you run it via UI. 

1 Create a Dockerfile. An definition of docker image to deploy on CE.
In this git, I do already have a SpringBoot app in jar. Dockerfile in this demo is super simple, it just runs the jar.
```
FROM openjdk:11-jdk-slim
COPY DockerTest-0.0.1-SNAPSHOT.jar springdoc.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/springdoc.jar"]  
```

2 build kicks in when you specifies this repo via CE. Repository and IBM Cloud CR detail are inherited from the UI.
It builds a docker image using Dockerfile in curent dir then pushes to CR.
```
# Build the image
docker build -t ${REPOSITORY}/sbdocker .

# And push it
docker push ${REPOSITORY}/sbdocker
```

3 Once build is done then run kicks in. Essentially by this line.
```
# Create the app
ibmcloud ce app create -n sbdocker --image ${REPOSITORY}/sbdocker
```

# Troubleshooting guide:
In case of build failure
```
$ ibmcloud ce buildrun list
Project 'test3' and all its contents will be automatically deleted 7 days from now.
Listing builds...
OK

Name                            Succeeded  Build Name            Age  
sbdocker-build-vpdn2-run-8mc6z  True       sbdocker-build-vpdn2  14m  
sbtest-build-lp7bn-run-gpstp    True       sbtest-build-lp7bn    23m  

---------------------------------------------

$ ibmcloud ce buildrun logs -n sbdocker-build-vpdn2-run-8mc6z
Project 'test3' and all its contents will be automatically deleted 7 days from now.
Getting build run 'sbdocker-build-vpdn2-run-8mc6z'...
Getting instances of build run 'sbdocker-build-vpdn2-run-8mc6z'...
Getting logs for build run 'sbdocker-build-vpdn2-run-8mc6z'...
OK
sbdocker-build-vpdn2-run-8mc6z-pz2d7-pod-v69bj/step-git-source-source-s559j:        
sbdocker-build-vpdn2-run-8mc6z-pz2d7-pod-v69bj/step-image-digest-exporter-sp9dg:    
sbdocker-build-vpdn2-run-8mc6z-pz2d7-pod-v69bj/step-step-build-and-push:   
```

Checking app status and logs. App will be auto scaled to 0 if there is no access. If it is scaled to 0, no logs will be shown.
```
$ ibmcloud ce app list
Project 'test3' and all its contents will be automatically deleted 7 days from now.
Listing all applications...
OK

Name      Status  URL                                                               Latest          Age  Conditions  Reason  
sbdocker  Ready   https://sbdocker.31ps9fcdswk.us-south.codeengine.appdomain.cloud  sbdocker-jwhvx  19m  3 OK / 3      
sbtest    Ready   https://sbtest.31ps9fcdswk.us-south.codeengine.appdomain.cloud    sbtest-95t5x    28m  3 OK / 3      

---------------------------------------------

$ ibmcloud ce application get --name sbdocker
Getting application 'sbdocker'...
Getting revisions for application 'sbdocker'...
Getting instances for application 'sbdocker'...
OK

Name:          sbdocker  
ID:            f2f3d880-b21c-4fef-8673-e58a267193b0  
Project Name:  test3  
Project ID:    26bb7757-e85f-40e2-a80b-5a3e13e70212  
Age:           20m  
Created:       2020-12-02 23:19:54 +1100 AEDT  
URL:           https://sbdocker.31ps9fcdswk.us-south.codeengine.appdomain.cloud  
Console URL:   https://cloud.ibm.com/codeengine/project/us-south/26bb7757-e85f-40e2-a80b-5a3e13e70212/application/sbdocker/configuration  

Image:                us.icr.io/kazuki_space/sbdocker:latest  
Resource Allocation:    
  CPU:                0.1  
  Ephemeral Storage:  500Mi  
  Memory:             1073741824  
Registry Secrets:       
  ibmcr  

Revisions:     
  sbdocker-jwhvx:    
    Age:                20m  
    Traffic:            100%  
    Image:              us.icr.io/kazuki_space/sbdocker:latest (pinned to 1d1c5e)  
    Running Instances:  0  

Runtime:       
  Concurrency:    100  
  Maximum Scale:  10  
  Minimum Scale:  0  
  Timeout:        300  

Conditions:    
  Type                 OK    Age  Reason  
  ConfigurationsReady  true  12m    
  Ready                true  12m    
  RoutesReady          true  12m    

---------------------------------------------

$ ibmcloud ce application logs --app sbdocker
Project 'test3' and all its contents will be automatically deleted 7 days from now.
Getting application 'sbdocker'...
Getting revisions for application 'sbdocker'...
Getting instances for application 'sbdocker'...
Getting logs for all instances of application 'sbdocker'...
OK

sbdocker-jwhvx-deployment-6dc5547897-vxkz4/user-container:    
.   ____          _            __ _ _  
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \  
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \  
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )  
  '  |____| .__|_| |_|_| |_\__, | / / / /  
 =========|_|==============|___/=/_/_/_/  
 :: Spring Boot ::                (v2.4.0)  
  
2020-12-02 12:43:57.998  INFO 1 --- [           main] com.example.demo.DockerTestApplication   : Starting DockerTestApplication v0.0.1-SNAPSHOT using Java 11.0.9.1 on sbdocker-jwhvx-deployment-6dc5547897-vxkz4 with PID 1 (/target/DockerTest-0.0.1-SNAPSHOT.jar started by root in /target)  
2020-12-02 12:43:58.195  INFO 1 --- [           main] com.example.demo.DockerTestApplication   : No active profile set, falling back to default profiles: default  
```
