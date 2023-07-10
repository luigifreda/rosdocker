## rosdocker

This repo contains a set of tools for managing docker containers and images, w/ and w/o **ROS**, and with transparent support of **nvidia drivers**.  
- The scripts below allow to run a container and transparently attach many terminals to it (bash prompt text and color will inform you where you are). 
- Each container shares its network interface with the host, so you can run this in multiple terminals for multiple hooks into the docker environment.
- You can trasparently run GUIs from each container and do not worry about nvidia libraries management.  
  
### Quick setup 

Check you have properly installed nvidia-docker.
* install docker-ce
https://docs.docker.com/install/linux/docker-ce/ubuntu/
* install nvidia-docker2 from here 
https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker 


### Run

Build and run a container: 
* build the container "*noetic*" (update it with the same command when you change the nvidia driver)
`$ ./build.sh noetic`
* run the container "*noetic*"  (open the first terminal starting the container)
`$ ./run.sh noetic`
* connect a new terminal to the same container 
`$ ./run.sh noetic`
* stop the container 
`$ ./stop.sh noetic`

If you want to use one of the other available containers (see next section), then just run: 
`$ ./build.sh <CONTAINER_NAME>`
`$ ./run.sh <CONTAINER_NAME>`
`$ ./stop.sh <CONTAINER_NAME>`

**NOTE**: any change made outside of your home directory from within the Docker environment will not persist. If you want to add additional binary packages without having to reinstall them each time, add them to the Dockerfile and rebuild.

Set the file config.sh (the env var `NVIDIA_DRIVER_VERSION` is automatically set)

### Available Containers and Dockerfiles 

- `melodic` (built on the top of `ros:melodic-ros-base-bionic`)  (`ubuntu:18.04`)
- `noetic` (built on the top of `ros:noetic-ros-base-focal`)  (`ubuntu:20.04`)
- `ubuntu20` (built on the top of `ubuntu:20.04`)
- `tradr` (built on the top of `ros:indigo`) (`ubuntu:14.04`) (it was used during the [TRADR](https://www.tradr-project.eu/) program)

Each container corresponds to a dockerfile: `Dockerfile_<CONTAINER_NAME>`. You can easily add your custom one. 


### Troubleshooting 

If you get the following error related to permission problems:
```
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/build?buildargs=%7B%22container_name%22%3A%22noetic%22%2C%22home%22%3A%22%2Fhome%2Fluigi%22%2C%22nvidia_driver_version%22%3A%22510%22%2C%22shell%22%3A%22%2Fbin%2Fbash%22%2C%22uid%22%3A%221000%22%2C%22user%22%3A%22luigi%22%2C%22workspace%22%3A%22%2Fhome%2Fluigi%2FWork%2Fdocker_ws%2Frosdocked%22%7D&cachefrom=%5B%5D&cgroupparent=&cpuperiod=0&cpuquota=0&cpusetcpus=&cpusetmems=&cpushares=0&dockerfile=Dockerfile_noetic&labels=%7B%7D&memory=0&memswap=0&networkmode=default&rm=1&shmsize=0&t=noetic&target=&ulimits=null&version=1": dial unix /var/run/docker.sock: connect: permission denied
```
then run the following commands (see this [link](https://phoenixnap.com/kb/docker-permission-denied) for instance)
```
$ sudo groupadd -f docker
$ sudo usermod -aG docker $USER
$ newgrp docker
$ sudo service docker restart
``` 

### Credits 

This repo was inspired by https://github.com/jbohren/rosdocked. Thanks to its Author. I've been using and improving this repo in background for years. Now, it's time to share it back.  