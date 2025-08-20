#!/bin/bash
set -euxo pipefail

pushd "$(dirname -- "$0")/.."

trap popd EXIT

readonly NAME=megaprocessor

if ! sudo docker inspect --type container "${NAME}" &>/dev/null; then

    if ! sudo docker inspect --type image "${NAME}" &>/dev/null; then
    
        sudo docker buildx build \
            --no-cache \
            -t "${NAME}" \
            -f docker/Dockerfile .
    fi
    
    sudo docker create \
        --name "${NAME}" \
        -v ./:/git \
        -e DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -u "$(id -u)" \
        --ipc host \
        "${NAME}"
fi

xhost local:root

sudo docker start "${NAME}"
