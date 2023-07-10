#!/usr/bin/env bash

set -e 

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./stop.sh CONTAINER_NAME"
  return 1
fi

export CONTAINER_NAME=$1 

source config.sh

docker stop $CONTAINER_NAME


