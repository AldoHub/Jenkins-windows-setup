#---- MAIN INSTALLATION STEPS ------

#----- Need to build a custom docker image since it will need blueocean and docker cli installed
#----- Download this file or copy it to make the new image for jenkins



#---- CUSTOMIZE OFFICIAL DOCKER IMAGE

#a. Create Dockerfile with the following content:
FROM jenkins/jenkins:2.401.2
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

#b. Build a new docker image from this Dockerfile and assign the image a meaningful name, e.g. "myjenkins-blueocean:2.401.2-1" 
#Run this on the root dir of the project using docker cli
#docker build -t myjenkins-blueocean:2.401.2-1 .


#---- CREATE A BRIDGE NETWORK IN DOCKER

#docker network create <my_network_name>
#--verify the networks using "docker network ls"

#---- RUN THE DOCKER CONTAINER

#docker run --name jenkins-blueocean --restart=on-failure --detach `
  #--network jenkins --env DOCKER_HOST=tcp://docker:2376 `
  #--env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 `
  #--volume jenkins-data:/var/jenkins_home `
  #--volume jenkins-docker-certs:/certs/client:ro `
  #--publish 8080:8080 --publish 50000:50000 myjenkins-blueocean:2.332.3-1