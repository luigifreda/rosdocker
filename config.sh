#!/usr/bin/env bash

source bash_utils.sh

THIS_DIR="$(cd "$(dirname "$BASH_SOURCE")"; pwd)"

# NOTE: this will create a new clean temporary "home" folder in the launching folder and will mount it as HOME folder in the launched container
export USE_TEMP_HOME=1
echo using USE_TEMP_HOME: $USE_TEMP_HOME


# NOTE: get the current version of the NVIDIA driver (from https://unix.stackexchange.com/questions/25663/how-to-get-the-version-of-my-nvidia-driver/417635#417635 )
# $ nvidia-smi --query-gpu=driver_version --format=csv,noheader
# The following variable is automatically set and must correctly reflect the currently used nvidia driver
export NVIDIA_DRIVER_VERSION=$(get_current_nvidia_driver_version)
echo using NVIDIA DRIVER: $NVIDIA_DRIVER_VERSION

# set default container name if it wasn't set up
if [[ -z "${CONTAINER_NAME}" ]]; then
    export CONTAINER_NAME=noetic  
fi
export DOCKER_FILE="Dockerfile_$CONTAINER_NAME"

# set the target bashrc file we are going to use  
export USED_BASHRC="bashrc" 
case $CONTAINER_NAME in
   "indigo") 
    USED_BASHRC="bashrc_tradr"
    DOCKER_FILE=Dockerfile_tradr 
   ;;
   "ubuntu20") 
    USED_BASHRC="bashrc"   
   ;;
   *) 
    USED_BASHRC="bashrc"
   ;;
esac

echo "CONTAINER_NAME=$CONTAINER_NAME"

export CONTAINER_BASHRC=$THIS_DIR/$USED_BASHRC
eval CONTAINER_BASHRC=$CONTAINER_BASHRC
echo "CONTAINER_BASHRC=$CONTAINER_BASHRC"
