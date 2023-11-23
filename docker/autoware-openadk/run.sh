#!/usr/bin/env bash
xhost +
docker run -it --rm --net=host --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix ghcr.io/autowarefoundation/autoware-openadk:monolithic-humble-x86_64 /bin/bash

