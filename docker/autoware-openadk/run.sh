#!/bin/sh
# This script is used to run Autoware ADK monolithic in a Docker container.

docker run -it --rm --privileged --net=host --runtime nvidia -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix \
    -v $HOME/.bash_aliases:/root/.bash_aliases -v $HOME/autoware_map:/autoware_map \
    ghcr.io/autowarefoundation/autoware-openadk:all-humble-latest-runtime /bin/bash