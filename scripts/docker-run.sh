#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
docker build -t chadbench:latest $SCRIPT_DIR/..

CHAD_GPU=$1
if [ -z "$1" ]; then
    CHAD_GPU="none"
fi

if [ $CHAD_GPU = "none" ]; then
    docker run -it \
        --rm \
        --name chadbench \
        --publish 7008:7008/udp \
        --publish 7009:7009/udp \
        --cap-add sys_nice \
        --ulimit nofile=1024 \
        --volume $(pwd)/$(dirname "$0")/..:/root/repo/:Z \
        chadbench:latest
elif [ $CHAD_GPU = "integrated" ]; then
    # with intel integrated gpu
    xhost +local:docker
    docker run -it \
        --rm \
        --name chadbench \
        --publish 7008:7008/udp \
        --publish 7009:7009/udp \
        --cap-add sys_nice \
        --ulimit nofile=1024 \
        --env DISPLAY=${DISPLAY} \
        --volume "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --volume $(pwd)/$(dirname "$0")/..:/root/repo/:Z \
        chadbench:latest
elif [ $CHAD_GPU = "nvidia" ]; then
    # with nvidia gpu
    xhost +local:docker
    docker run -it \
        --rm \
        --name chadbench \
        --publish 7008:7008/udp \
        --publish 7009:7009/udp \
        --cap-add sys_nice \
        --ulimit nofile=1024 \
        --runtime nvidia \
        --gpus all \
        --env DISPLAY=${DISPLAY} \
        --env __NV_PRIME_RENDER_OFFLOAD=1 \
        --env __GLX_VENDOR_LIBRARY_NAME=nvidia \
        --env NVIDIA_VISIBLE_DEVICES=all \
        --env NVIDIA_DRIVER_CAPABILITIES=all \
        --volume "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --volume $(pwd)/$(dirname "$0")/..:/root/repo/:Z \
        chadbench:latest
elif [ $CHAD_GPU = "amd" ]; then
    # with amd gpu
    # xhost +local:docker
    echo "amd implementation not tested yet (need an amd gpu first)"
else
    echo "usage: scripts/docker-run [none, integrated, nivida, amd]"
    exit -1
fi
