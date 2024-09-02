#!/usr/bin/env bash

# a collection of bash utils 

function print_blue(){
	printf "\033[34;1m"
	printf "$@ \n"
	printf "\033[0m"
}

function make_dir(){
if [ ! -d $1 ]; then
    mkdir -p $1
fi
}
function make_buid_dir(){
	make_dir build
}

function extract_version(){
    #version=$(echo $1 | sed 's/[^0-9]*//g')
    #version=$(echo $1 | sed 's/[[:alpha:]|(|[:space:]]//g')
    #version=$(echo $1 | sed 's/[[:alpha:]|(|[:space:]]//g' | sed s/://g)  
    version=$(echo "$1" | cut -d. -f1 | cut -d' ' -f1)    
    echo $version
}

function get_current_nvidia_driver_version(){
    # check if nvidia-smi is installed
    if ! command -v nvidia-smi &> /dev/null; then
        echo ""
        return
    fi

    NVIDIA_DRIVER_STRING=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
    NVIDIA_DRIVER_VERSION=$(extract_version "$NVIDIA_DRIVER_STRING")
    echo "$NVIDIA_DRIVER_VERSION"
}
