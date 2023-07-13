# rosdocker

This repo contains a set of tools for managing docker containers and (ROS) images with a transparent support of **nvidia drivers**. You can play with it to create your own custom docker containers. If you are new to docker or look for a quick cheatsheet start [here](docker_commands.md).

**Main features**:
- You can run a container and transparently attach many terminals to it: text and color of the bash prompt will inform you where you are. 
- Each container shares its network interface with the host.
- GUIs can be run from each container terminal (nvidia drivers are transparently managed). For instance, you can run `rviz`.  
- You favorite working folder is conveniently imported into the docker containers when you run them. 
  
## Requirements

Check you have installed the *[nvidia-docker-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#tab-0-0-0)*:   
`$ sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit-base`  

## Usage

### Configuration 

In the file [config.sh](./config.sh), set your favorite *working folder* `WORKING_FOLDER_TO_MOUNT_IN_CONTAINER`. This folder will be mounted from the host into the run container so that we can continue our work within the container. By default, we have:    
`WORKING_FOLDER_TO_MOUNT_IN_CONTAINER="$HOME/Work"`       


### Build and run  

Build and run a container `<CONTAINER_NAME>`: 
* build the container     
`$ ./build.sh <CONTAINER_NAME>`     
* run the container from a first terminal (that spawns the container)    
`$ ./run.sh <CONTAINER_NAME>`     
* connect a new terminal to the same container    
`$ ./run.sh <CONTAINER_NAME>`     
* stop the container     
`$ ./stop.sh <CONTAINER_NAME>`     

For instance, if you want to run and build the `noetic` container (see [next section](#available-containers-and-dockerfiles) for available containers), then run:   
`$ ./build.sh noetic`     
`$ ./run.sh noetic`    
`$ ./stop.sh noetic`   

**NOTE1**: When you update your nvidia drivers, rebuild the container with the `build.sh` script. 

**NOTE2**: any change made outside of our folder `WORKING_FOLDER_TO_MOUNT_IN_CONTAINER` from within the docker environment will not persist. If you want to add additional binary packages without having to reinstall them each time, add them to the Dockerfile and rebuild. This is a trivial thing for normal docker users. 

## Available Images and Dockerfiles 

Each container `<CONTAINER_NAME>` listed below corresponds to a dockerfile: `Dockerfile_<CONTAINER_NAME>`. 

- `melodic` built on the top of `ros:melodic-ros-base-bionic` (`ubuntu:18.04`)
- `noetic` built on the top of `ros:noetic-ros-base-focal` (`ubuntu:20.04`)
- `noetic_3dmr` layered built on the top of the previous `noetic` and installing all the deps of [3DMR](https://github.com/luigifreda/3dmr.git))  (`ubuntu:20.04`)
- `ubuntu20` built on the top of `ubuntu:20.04` (no ROS)
- `humble`  built on the top of `ros:humble` (`ubuntu:22.04`)
- `ubuntu22` built on the top of `ubuntu:22.04` (no ROS)
  
An old heritage:  
- `tradr` (built on the top of `ros:indigo`) (`ubuntu:14.04`) (it was used during the [TRADR](https://www.tradr-project.eu/) program)

Now, you can easily add your new custom one. 

## 3DMR 

In order to run the `noetic_3dmr`container (layered build) necessary for the [3DMR project](https://github.com/luigifreda/3dmr), check you are connected to the network and run:     
`$ ./build.sh noetic`     
`$ ./build.sh noetic_3dmr`      

Now, from your host, clone [3DMR](https://github.com/luigifreda/3dmr) into your folder `$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER`. Then, run the container `noetic_3dmr`:    
`$ ./run.sh noetic_3dmr`.    
Next, from within that container, get into the folder `$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER`, and then build the workspace (see the instructions in [3DMR](https://github.com/luigifreda/3dmr)). 

## Troubleshooting 

If you get the following error related to permission problems:
```
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post ": dial unix /var/run/docker.sock: connect: permission denied
```
then run the following commands:
```
$ sudo groupadd -f docker
$ sudo usermod -aG docker $USER
$ newgrp docker
$ sudo service docker restart
``` 

## References

* a cheatsheet is available in this repo: [here](docker_commands.md).
* nice intro/demo for docker 
  https://www.youtube.com/watch?v=XcJzOYe3E6M 
* install nvidia container toolkit     
  https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker 
* permission denied issue     
  https://phoenixnap.com/kb/docker-permission-denied
* nice cheatsheet/tutorials: 
  https://www.edureka.co/blog/docker-commands/#rm 
  https://shisho.dev/blog/posts/docker-remove-cheatsheet/

## Credits 

This repo was initially inspired by https://github.com/jbohren/rosdocked. Thanks to its Author. I've been using and improving this repo in background for years. Now, it's time to share it back.  