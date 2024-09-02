#!/usr/bin/env bash

source bash_utils.sh

CONFIG_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$(readlink -f $CONFIG_DIR)  # this reads the actual path if a symbolic directory is used
#echo CONFIG_DIR: $CONFIG_DIR

# =====================================
# Options 

# This working folder will be mounted from the host into the run container.
# In this way, we can continue our work within the docker container.
export WORKING_FOLDER_TO_MOUNT_IN_CONTAINER="$HOME/Work"
echo WORKING_FOLDER_TO_MOUNT_IN_CONTAINER: $WORKING_FOLDER_TO_MOUNT_IN_CONTAINER

# This will create a local "home" folder in the launching folder and will mount it as HOME folder in the launched container
export USE_LOCAL_HOME_FOLDER=0  # 1 create a local home folder as explained (will be used in the run.sh script)
                                # 0 no, I don't want that 
echo USE_LOCAL_HOME_FOLDER: $USE_LOCAL_HOME_FOLDER


# =====================================

# Get the current version of the NVIDIA driver (from https://unix.stackexchange.com/questions/25663/how-to-get-the-version-of-my-nvidia-driver/417635#417635 )
# $ nvidia-smi --query-gpu=driver_version --format=csv,noheader
# The following variable is automatically set and must correctly reflect the currently used nvidia driver
export NVIDIA_DRIVER_VERSION=$(get_current_nvidia_driver_version)
if [[ "${NVIDIA_DRIVER_VERSION}" != "" ]]; then
    echo Using NVIDIA DRIVER: $NVIDIA_DRIVER_VERSION
fi 

# Set default container name if it wasn't set up
if [[ -z "${CONTAINER_NAME}" ]]; then
    export CONTAINER_NAME=noetic  
fi
export DOCKER_FILE="Dockerfile_$CONTAINER_NAME"
echo "CONTAINER_NAME=$CONTAINER_NAME"

