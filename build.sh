#!/usr/bin/env bash

set -e 

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_DIR=$(readlink -f $SCRIPT_DIR)  # this reads the actual path if a symbolic directory is used

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./build.sh CONTAINER_NAME"
  return 1
fi

export CONTAINER_NAME=$1 

source config.sh

echo building container $CONTAINER_NAME with $DOCKER_FILE
sleep 1

TIMEZONE=""
case "$OSTYPE" in
  darwin*)
    TIMEZONE=$(sudo systemsetup -gettimezone | sed 's/^Time Zone: //')
    ;;
  linux*)
    TIMEZONE=$(cat /etc/timezone)
    ;;
  *)
    echo "";
    ;;
esac

# Build the docker image (update the nvidia driver version if needed)
docker build -f "$DOCKER_FILE" --rm\
  --build-arg user=$USER\
  --build-arg uid=$UID\
  --build-arg home=$HOME\
  --build-arg workspace=$SCRIPT_DIR\
  --build-arg shell=$SHELL\
  --build-arg nvidia_driver_version="$NVIDIA_DRIVER_VERSION"\
  --build-arg container_name=$CONTAINER_NAME\
  --build-arg timezone=$TIMEZONE\
  -t $CONTAINER_NAME .
