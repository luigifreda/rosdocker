#!/usr/bin/env bash

set -e 
#set -x 

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./run.sh CONTAINER_NAME"
  return 1
fi

export CONTAINER_NAME=$1 

# first set the container name and then source the config file
source config.sh


# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

set -e

# from  http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration  (with nvidia-docker2)
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

# N.B.: 
# -v is used to map folders and files from your_os::src to docker_container::dst  (!if you do not map them, yo do not see them!)

if [ "$(docker ps -a | grep ${CONTAINER_NAME})" ]; then
    echo "Attaching to running container $CONTAINER_NAME ..."
    docker exec -it \
            -e SHELL \
            -e USER \
            -e DISPLAY \
            --privileged \
            $1 $SHELL
else
    echo "Starting container $CONTAINER_NAME ..."
    
    # create a new clean temporary "home" folder in the launching folder and mount it as HOME folder in the container
    if [ $USE_TEMP_HOME -eq 1 ]; then 
        echo 'creating a temporary folder'
        TEMP_HOME_FOLDER=`pwd`/"temp_home_$CONTAINER_NAME"
        if [ ! -d $TEMP_HOME_FOLDER ]; then
            mkdir -p $TEMP_HOME_FOLDER
            chmod 0777 $TEMP_HOME_FOLDER
        fi 
        # mount the temporary folder as new HOME
        HOME_OPTIONS="-v "$TEMP_HOME_FOLDER:$HOME":rw"
        # mount the actual $HOME/Work folder as $HOME/Work (so we can find the code)
        HOME_OPTIONS+=" -v "$HOME/Work":"$HOME/Work":rw"
    else
        HOME_OPTIONS="-v "$HOME:$HOME":rw"
        if [ -d $TEMP_HOME_FOLDER ]; then    
            HOME_OPTIONS+=" -v "$HOME/Work":"$HOME/Work":rw"  # added synce my "Work" folder is a symbolic link
        fi
    fi 

    docker run -it --rm \
            --net=host\
            -e SHELL \
            -e USER \
            -e DISPLAY \
            -e DOCKER=1 \
            -e XAUTHORITY=${XAUTH} \
            -v $XSOCK:$XSOCK:rw \
            -v $XAUTH:$XAUTH:rw \
            $HOME_OPTIONS \
            -v $CONTAINER_BASHRC:$HOME/.bashrc \
            -v /usr/local/V-REP_PRO_EDU_V3_5_0_Linux:/usr/local/V-REP_PRO_EDU_V3_5_0_Linux \
            -v /media:/media -v /mnt:/mnt -v /dev:/dev  -v $HOME/.ssh:$HOME/.ssh \
            --runtime=nvidia \
            --privileged \
            --name $CONTAINER_NAME \
      $1 $SHELL
fi 
