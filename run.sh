#!/usr/bin/env bash

set -e 
#set -x 

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./run.sh <CONTAINER_NAME>"
  exit 1
fi

export CONTAINER_NAME=$1 

# First set the container name and then source the config file
source config.sh


# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

set -e

# From  http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration  (with nvidia-docker2)
xhost + $(hostname)
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]; then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    touch $XAUTH
    if [ ! -z "$xauth_list" ]; then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

DISPLAY_OPTIONS=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    # allow access from localhost (from https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb)
    echo "Starting XQuartz and allowing access to it..."
    # NOTE: from https://gist.github.com/cschiewek/246a244ba23da8b9f0e7b11a68bf3285?permalink_comment_id=4198715 
    # 1. Install XQuartz: https://www.xquartz.org/
    #   brew install --cask xquartz 
    # 2. Launch XQuartz. Under the XQuartz menu, select Preferences
    # 3. Go to the security tab and ensure "Allow connections from network clients" is checked.
    open -a XQuartz 
    xhost + $(hostname)
    touch $XAUTH

    #DISPLAY_OPTIONS="$(hostname):0"
    DISPLAY_OPTIONS=host.docker.internal:0

    # NOTE: you may need to run this inside docker: 
    echo You may need to run the following command inside docker:
    echo "  export LIBGL_ALWAYS_INDIRECT=1"
fi  
if [[ "$OSTYPE" == "linux"* ]]; then 
    DISPLAY_OPTIONS=$DISPLAY
fi 

# N.B.: 
# -v is used to map folders and files from your_os::src to docker_container::dst  (!if you do not map them, yo do not see them!)

if [ "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
    echo "Attaching to running container $CONTAINER_NAME ..."
    docker exec -it \
            -e SHELL \
            -e USER \
            -e DISPLAY="$DISPLAY_OPTIONS"  \
            --privileged \
            $1 $SHELL
else
    echo "Starting container $CONTAINER_NAME ..."
    
    # Below we use some of the options we set in the config.sh file 
    
    # Create a permanent local "home" folder in the host and mount it as HOME folder in the container
    if [ $USE_LOCAL_HOME_FOLDER -eq 1 ]; then 
        LOCAL_HOME_FOLDER=`pwd`/"local_home_$CONTAINER_NAME"
        echo 'Creating a permanent local home folder'
        if [ ! -d $LOCAL_HOME_FOLDER ]; then
            mkdir -p $LOCAL_HOME_FOLDER
            chmod 0777 $LOCAL_HOME_FOLDER
        fi 
        # Mount the local "home" folder as new HOME in the container
        HOME_OPTIONS="-v "$LOCAL_HOME_FOLDER:$HOME":rw"
    #else
        # Mount the full home folder in the container
        #HOME_OPTIONS="-v "$HOME:$HOME":rw"
    fi 
    
    # Mount the $WORKING_FOLDER_TO_MOUNT_IN_CONTAINER as $WORKING_FOLDER_TO_MOUNT_IN_CONTAINER into the run container
    # In this way, we can continue our work within the docker container.
    HOME_OPTIONS+=" -v "$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER":"$WORKING_FOLDER_TO_MOUNT_IN_CONTAINER":rw"

    user_id=$(id -u)
    group_id=$(id -g)
    UID_OPTIONS="-u $user_id:$group_id"

    NVIDIA_OPTIONS=""
    if [[ "$OSTYPE" == "linux"* ]]; then 
        # check if nvidia runtime is available
        if [ -z "$(docker info | grep -i 'runtime' | grep -i 'nvidia')" ]; then
            echo "NVIDIA runtime is not available"
            NVIDIA_OPTIONS=""
        else
            NVIDIA_OPTIONS="--gpus all -e NVIDIA_DRIVER_CAPABILITIES=all -e NVIDIA_VISIBLE_DEVICES=all --runtime=nvidia"
        fi
    fi 

    SHARED_MEMORY_OPTIONS="--ipc=host --shm-size=16g"


    MOUNT_OPTIONS=""
    if [[ "$OSTYPE" == "linux"* ]]; then 
        MOUNT_OPTIONS="-v /media:/media -v /mnt:/mnt -v /dev:/dev"  # not working under macOS
    fi 

    docker run -it --rm \
            --net=host \
            $SHARED_MEMORY_OPTIONS \
            --privileged $UID_OPTIONS \
            -e SHELL \
            -e USER \
            -e DISPLAY="$DISPLAY_OPTIONS" \
            -e DOCKER=1 \
            -e XAUTHORITY=${XAUTH} \
            -v $XSOCK:$XSOCK:rw \
            -v $XAUTH:$XAUTH:rw \
            $HOME_OPTIONS $MOUNT_OPTIONS $NVIDIA_OPTIONS \
            -v $HOME/.ssh:$HOME/.ssh \
            --name $CONTAINER_NAME \
      $1 $SHELL
fi 
