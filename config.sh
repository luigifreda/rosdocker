#!/usr/bin/env bash

source bash_utils.sh

THIS_DIR="$(cd "$(dirname "$BASH_SOURCE")"; pwd)"

# =====================================
# Options 

# This working folder will be mounted from the host into the run container.
# In this way, we can continue our work within the docker container.
export WORKING_FOLDER_TO_MOUNT_IN_CONTAINER="$HOME/Work"
echo WORKING_FOLDER_TO_MOUNT_IN_CONTAINER: $WORKING_FOLDER_TO_MOUNT_IN_CONTAINER

# This will create a local "home" folder in the launching folder and will mount it as HOME folder in the launched container
export USE_LOCAL_HOME_FOLDER=0  # 1 create a local home folder as explained
                                # 0 no, I don't want that 
echo USE_LOCAL_HOME_FOLDER: $USE_LOCAL_HOME_FOLDER


# =====================================

# Get the current version of the NVIDIA driver (from https://unix.stackexchange.com/questions/25663/how-to-get-the-version-of-my-nvidia-driver/417635#417635 )
# $ nvidia-smi --query-gpu=driver_version --format=csv,noheader
# The following variable is automatically set and must correctly reflect the currently used nvidia driver
export NVIDIA_DRIVER_VERSION=$(get_current_nvidia_driver_version)
echo Using NVIDIA DRIVER: $NVIDIA_DRIVER_VERSION

# Set default container name if it wasn't set up
if [[ -z "${CONTAINER_NAME}" ]]; then
    export CONTAINER_NAME=noetic  
fi
export DOCKER_FILE="Dockerfile_$CONTAINER_NAME"

# Set the target bashrc file we are going to use  
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
