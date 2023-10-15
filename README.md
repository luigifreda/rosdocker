# rosdocker 
## 🤖 🐳

This repository contains a set of tools that simplify the management of docker containers and (ROS) images with transparent support of NVIDIA drivers. You can play with it to create your own custom docker containers. A docker cheatsheet is available [here](docker_commands.md).

**Main features**:
- Run a container and transparently attach many terminals to it: text and color of the bash prompt will inform you where you are. Try it!
- GUIs can be run from each container terminal (NVIDIA drivers are transparently managed). For instance, you can run `rviz` from a run container terminal. 
- Each container shares its network interface with the host.
- Your favorite working folder is conveniently mounted into the docker containers when you run them. 
  
## Requirements

Check you have installed the *[nvidia-docker-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#tab-0-0-0)*:   
`$ sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit-base`  

## Usage

### Configuration 

In the file [config.sh](./config.sh), set your favorite *working folder* `WORKING_FOLDER_TO_MOUNT_IN_CONTAINER`. This folder will be mounted from the host into the run container so that we can conveniently work ont it and preserve changes. By default:    
`WORKING_FOLDER_TO_MOUNT_IN_CONTAINER="$HOME/Work"`       


### Build and run  

Consider one of our [available dockerfiles](#available-images-and-dockerfiles) `Dockerfile_<NAME>`. 
* Build the image:      
`$ ./build.sh <NAME>`     
* Run the container from a first terminal (this spawns the container)    
`$ ./run.sh <NAME>`     
* Open a new terminal and connect to the running container     
`$ ./run.sh <NAME>`     
* Stop the container     
`$ ./stop.sh <NAME>`     

For instance, if you want to build, run and stop the `noetic` container/image corresponding to `Dockerfile_noetic`, then run:   
`$ ./build.sh noetic`     
`$ ./run.sh noetic`    
`$ ./stop.sh noetic`   

**NOTE1**: When you update your Nvidia drivers, rebuild the image with the `build.sh` script. 

**NOTE2**: any change made outside of our folder `WORKING_FOLDER_TO_MOUNT_IN_CONTAINER` from within the docker environment will not persist. If you want to add additional binary packages without having to reinstall them each time, add them to the Dockerfile and rebuild. This is a well known rule for docker users. 

## Available Images and Dockerfiles 

Each image `<NAME>` listed below corresponds to a dockerfile: `Dockerfile_<NAME>`. 

- `melodic` built on top of `ros:melodic-ros-base-bionic` (`ubuntu:18.04`)
- `noetic` built on top of `ros:noetic-ros-base-focal` (`ubuntu:20.04`)
- `noetic_3dmr` built on top of the previous `noetic` and installing all the deps of [3DMR](https://github.com/luigifreda/3dmr.git))  (`ubuntu:20.04`)
- `ubuntu20` built on top of `ubuntu:20.04` (no ROS)
- `pyslam` built on top of `ubuntu:18.04` 
- `humble`  built on the top of `ros:humble` (`ubuntu:22.04`)
- `ubuntu22` built on top of `ubuntu:22.04` (no ROS)
  
An old heritage:  
- `tradr` (built on top of `ros:indigo`) (`ubuntu:14.04`) (it was used during the [TRADR](https://www.tradr-project.eu/) program)

Now, you can easily add your new custom docker file. 

## 3DMR 

In order to build the `noetic_3dmr` image, which can host the [3DMR project](https://github.com/luigifreda/3dmr), check you are connected to the network and run these commands:     
`$ ./build.sh noetic`     
`$ ./build.sh noetic_3dmr`      

Now, set your folder `$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER` (see the [configuration](#configuration) section). From your host, open a terminal and clone the [3DMR](https://github.com/luigifreda/3dmr) project into `$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER`. Then, run the container `noetic_3dmr`:    
`$ ./run.sh noetic_3dmr`.      
Next, from within the run container, get into the folder `$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER`, and build the workspace (see the instructions and scripts in [3DMR](https://github.com/luigifreda/3dmr)). 

## pyslam 

To build the `pyslam` image, which can host [pyslam](https://github.com/luigifreda/pyslam), check you are connected to the network and run:  
`$ ./build.sh pyslam`.      
Then, open a terminal and run: 
`$ ./run.sh pyslam`.      
Now, withint the run container, you can find the `pyslam` folder ready to be used in `/tmp` .  

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

* I created a docker cheatsheet [here](docker_commands.md).
* Nice intro/demo for docker:
  https://www.youtube.com/watch?v=XcJzOYe3E6M 
* Install Nvidia container toolkit:   
  https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker 
* Permission denied issue:     
  https://phoenixnap.com/kb/docker-permission-denied
* Nice cheatsheet/tutorials: 
  https://www.edureka.co/blog/docker-commands/#rm 
  https://shisho.dev/blog/posts/docker-remove-cheatsheet/

## Credits 

This repository was initially inspired by https://github.com/jbohren/rosdocked. Thanks to its Author. I've been using and improving this repo in the background for years. Now, it's time to share it back.  
