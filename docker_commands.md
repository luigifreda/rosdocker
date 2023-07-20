# Docker

You can find a list of docker commands below. If you are new to docker then start with this nice [demo](https://www.youtube.com/watch?v=XcJzOYe3E6M).

## Commands 
### Containers 

**Running a container**     
To create a container from an image:     
`docker run -it -d <image name> `     

**Checking running containers**      

Check which containers are running at the present time:     
`docker container ls`     

You can also use:      
`docker ps`     
or      
`docker ps -a`     
to show all the running and exited containers.     

**Stopping and killing containers**     
To stop a running container:     
`docker stop <container id>`     

To kill a container by stopping its execution immediately:     
`docker kill <container id>`     

**Removing containers**     
To remove/delete a stopped container:     
`docker rm <container id>`     

Removing all stopped containers:     
`docker container prune`     

Stop and remove all containers:      
`docker stop $(docker ps -a -q)`     
`docker rm $(docker ps -a -q)`     

### Images

**Checking local available images**      
Check which image are available:     
`docker image ls`     

**Pulling images**
To pull images from the [docker repository](hub.docker.com):     
`docker pull <image name>`     


**Remove images** 
Remove an image:     
`docker image rm <id>`     

Remove dangling images:     
`docker image prune`     
Remove unused images:      
`docker image prune -a`     

Remove all images:      
`docker rmi --force $(docker images -a -q)`     

### Cleaning the system      
To delete unused docker objects (images, containers, volumes, network) all at once:      
`docker system prune`     


### First docker setup     
```
sudo groupadd docker     
sudo usermod -aG docker $USER     
```
Log out and log back in to start using docker without sudo. More details [here](https://docs.docker.com/engine/install/linux-postinstall/)


## References

* Nice intro/demo for docker 
  https://www.youtube.com/watch?v=XcJzOYe3E6M 
* Nice cheatsheet/tutorials: 
  https://www.edureka.co/blog/docker-commands/#rm 
  https://shisho.dev/blog/posts/docker-remove-cheatsheet/