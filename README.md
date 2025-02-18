# rosdocker  🤖 🐳

<!-- TOC -->

- [rosdocker  🤖 🐳](#rosdocker---)
  - [Requirements](#requirements)
  - [Usage](#usage)
    - [Configuration](#configuration)
    - [Build and run](#build-and-run)
  - [Available Images and Dockerfiles](#available-images-and-dockerfiles)
    - [3DMR](#3dmr)
    - [pyslam](#pyslam)
  - [Troubleshooting](#troubleshooting)
    - [docker: Error response from daemon: could not select device driver with capabilities: gpu](#docker-error-response-from-daemon-could-not-select-device-driver-with-capabilities-gpu)
    - [Permissions problems](#permissions-problems)
  - [References](#references)
  - [Credits](#credits)

<!-- /TOC -->

This repository contains a set of tools that simplifies the management of docker containers and (ROS) images with transparent support of NVIDIA drivers. You can play with it to create your own custom docker containers, smoothly open many terminals connected to them, and move from one container to another one. A docker cheatsheet is available [here](docker_commands.md).

**Main features**:
- Run a container and transparently attach many terminals to it: text and color of the bash prompt will inform you where you are. Try it!
- Applications with a GUI can be smoothly run from each container terminal (NVIDIA drivers are transparently managed). For instance, you can run `rviz` from a run container terminal without any issue. 
- Each container shares its network interface with the host.
- Your favorite working folder is conveniently mounted into the docker containers when you run them and you can easily build and run applications from there. 
  
---
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

---
## Available Images and Dockerfiles 

Each image `<NAME>` listed below corresponds to a dockerfile: `Dockerfile_<NAME>`. 

- `ubuntu18` built on top of `ubuntu:18.04` (no ROS)
- `ubuntu18_cuda` built on top of `nvidia/cuda:11.8.0-devel-ubuntu18.04` (no ROS)
- `melodic` built on top of `ros:melodic-ros-base-bionic` (`ubuntu:18.04`)
- `noetic` built on top of `ros:noetic-ros-base-focal` (`ubuntu:20.04` with ROS)
- `noetic_cuda` built on top of `nvidia/cuda:12.2.2-devel-ubuntu20.04` (`ubuntu:20.04` with ROS and CUDA)
- `noetic_3dmr` built on top of the previous `noetic` and installing all the deps of [3DMR](https://github.com/luigifreda/3dmr.git)  (`ubuntu:20.04`)
- `ubuntu20` built on top of `ubuntu:20.04` (no ROS)
- `ubuntu20_conda` built on top of `ubuntu:20.04` with `conda` for managing python (no ROS)
- `ubuntu20_cuda` built on top of `nvidia/cuda:12.2.2-devel-ubuntu20.04` (no ROS, with CUDA)
- `pyslam` built on top of `ubuntu:20.04`  and installing all the deps of [pyslam](https://github.com/luigifreda/pyslam) *=>* you can now pull the image from [here](https://github.com/users/luigifreda/packages/container/package/rosdocker)
- `pyslam_cuda` built on top of `nvidia/cuda:12.1.0-devel-ubuntu20.04` and installing all the deps of [pyslam](https://github.com/luigifreda/pyslam) with CUDA support *=>* you can now pull the image from [here](https://github.com/users/luigifreda/packages/container/package/rosdocker)
- `humble`  built on the top of `ros:humble` (`ubuntu:22.04`)
- `ubuntu22` built on top of `ubuntu:22.04` (no ROS)
- `ubuntu22_cuda` built on top of `nvidia/cuda:11.8.0-devel-ubuntu22.04` (no ROS, with CUDA) 
- `ubuntu22_cuda_conda` built on top of `nvidia/cuda:11.8.0-devel-ubuntu22.04` with `conda` (no ROS, with CUDA) 
- `ubuntu24` built on top of `ubuntu:24.04` (no ROS)
- `ubuntu24_cuda` built on top of `nvidia/cuda:12.5.1-devel-ubuntu24.04` (no ROS, with CUDA) 
  
An old heritage:  
- `tradr` (built on top of `ros:indigo`) (`ubuntu:14.04`) (it was used during the [TRADR](https://www.tradr-project.eu/) program)

Now, you can easily add your new custom docker file. 

---
### 3DMR  

In order to build the `noetic_3dmr` image, which can host the [3DMR project](https://github.com/luigifreda/3dmr), check you are connected to the network and run these commands:     
`$ ./build.sh noetic`     
`$ ./build.sh noetic_3dmr`      

Now, set your folder `$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER` (see the [configuration](#configuration) section). From your host, open a terminal and clone the [3DMR](https://github.com/luigifreda/3dmr) project into `$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER`. Then, run the container `noetic_3dmr`:    
`$ ./run.sh noetic_3dmr`.      
Next, from within the run container, get into the folder `$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER`, and build the workspace (see the instructions and scripts in [3DMR](https://github.com/luigifreda/3dmr)). 

---
### pyslam 

To build the `pyslam` / `pyslam_cuda` image, which can host the [pyslam](https://github.com/luigifreda/pyslam) project, check you are connected to the network and run:  
`$ ./build.sh pyslam`         
or        
`$ ./build.sh pyslam_cuda` if your system supports NVIDIA CUDA      
Then, open a terminal and run:      
`$ ./run.sh pyslam`       
or         
`$ ./run.sh pyslam_cuda` if you built the image with NVIDIA CUDA support.           
Now, within the run container, you can find a copy of `pyslam` ready to be used in your user's home folder.  

---
## Troubleshooting 

### docker: Error response from daemon: could not select device driver with capabilities: gpu

It might be a good time to install the *[nvidia-docker-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#tab-0-0-0)* as suggested above. 

### Permissions problems

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

---
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
* NVIDIA CUDA and cuDNN images from gitlab.com/nvidia/cuda  
  https://hub.docker.com/r/nvidia/cuda

---
## Credits 

This repository was initially inspired by https://github.com/jbohren/rosdocked. Thanks to its Author. I've been using and improving this repo in the background for years. Now, it's time to share it back.  
