# Building Unity Projects Using Docker

All main Docker files, bash scripts and notes to setup the automated building process of a Unity project:

* Dockerfiles for spcecific platforms are located under their separate Dockerfiles subfolders

* The Main folder containes:
  * The main build.sh script, used in each built Docker image is under the Main folder
  * The prep_docker_images.sh script, which removes old built images and rebuilds new, updated ones
  * The docker-compose.yml used to start and launch the built containers

* The Notes folder is meant purely to collect useful Docker and git commands, which were used throughout the project

NOTE: The repository does not include sensitive data such as the private ssh key used to setup GitHub access on Docker images, Unity serial number used to authenticate the used license and Unity login data. As such the authentication ssh key needs to be generated on your end and the Unity specific credentials have to come from you.
