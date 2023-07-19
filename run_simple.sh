#!/usr/bin/env bash


# NOTE: use this script for creating a container from any image available with 
# $ docker image ls 


set -e 
#set -x 

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./run_simple.sh <IMAGE_NAME>"
  exit 1
fi

export IMAGE_NAME=$1 
export CONTAINER_NAME=$IMAGE_NAME   # assign a container name with the same name of the input image name 

#source config.sh
#source bash_utils.sh

docker run --gpus all --net=host -it --privileged --name $CONTAINER_NAME $IMAGE_NAME 