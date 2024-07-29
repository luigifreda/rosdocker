#!/usr/bin/env bash


#set -e 
#set -x 

function print_blue(){
	printf "\033[34;1m"
	printf "$@ \n"
	printf "\033[0m"
}

# usage: 
# open_term "NAME_SESSION" "COMMAND_STRING"
# N.B.: "NAME_SESSION" must be a single word without spaces 
function open_screen(){
    session_name=$1
    command_string=${@:2}
    #screen -dmS session_name -Lc file_init  
    screen -dmS $session_name -L  
    screen -S $session_name -L -X stuff $"$command_string \n"   
}

function wait_for_docker_container(){
    docker_container=$1
    check=""
    while true; do
        echo waiting for docker container $docker_container...
        check=$(docker ps -a | grep "$docker_container")
        if [ -n "$check" ]; then # 
            break 
        fi
        sleep 1
    done 
    echo docker container $docker_container started    
}

# kill a screen session 
# screen -XS <session-id> quit

# To push a docker images on [ghcr.io/luigifreda/rosdocker](https://ghcr.io/luigifreda/rosdocker):
# - Run that target image to in a container `<current_running_container>`
# - Then, run 
#   `docker commit <current_running_container> ghcr.io/luigifreda/rosdocker:<new-docker-tag>`
# - Finally, in order to push and share the image
#   `docker image push ghcr.io/luigifreda/rosdocker:<new-docker-tag>`

function update_docker_commit_and_push(){
    print_blue "======================================================="
    print_blue "updating docker image ghcr.io/luigifreda/rosdocker:$1"
    docker_container=$1
    ./build.sh $docker_container
    echo "now running docker container $docker_container..."
    open_screen "$docker_container" "./run.sh $docker_container" &
    wait_for_docker_container $docker_container
    screen -list | grep $docker_container
    docker commit $docker_container ghcr.io/luigifreda/rosdocker:$docker_container
    docker image push ghcr.io/luigifreda/rosdocker:$docker_container
    echo "quitting docker container $docker_container running under screen session $docker_container..."
    screen -XS $docker_container quit
}
# clear all screen sessions
killall screen; screen -wipe

update_docker_commit_and_push pyslam_cuda
update_docker_commit_and_push pyslam

./build.sh noetic # required for building noetic_3dmr
update_docker_commit_and_push noetic_3dmr
