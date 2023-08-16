#!/usr/bin/env bash
# This script is used to run Autoware Open AD Kit runtime container(s).

set -e

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")
WORKSPACE_ROOT="$SCRIPT_DIR/../../"

if [ "$1" = "--monolithic" ]; then
    option_monolithic=true
else
    option_monolithic=false
fi

# source env vars
platform="x86_64"
source "$WORKSPACE_ROOT/amd64.env"
if [ "$(uname -m)" = "aarch64" ]; then
    platform="aarch64"
    source "$WORKSPACE_ROOT/arm64.env"
fi

export platform
export rosdistro
export services_ros_domain_id

# run awf runtime container(s)
xhost +
if [ "$option_monolithic" = "true" ]; then
    docker run -it --rm --privileged --net=host --gpus all -e DISPLAY=$DISPLAY \
    -e ROS_DOMAIN_ID=$services_ros_domain_id -v /tmp/.X11-unix/:/tmp/.X11-unix -v /var/tmp/autoware_amp:/autoware_map \
    ghcr.io/autowarefoundation/autoware-openadk:runtime-monolithic-$rosdistro-$platform /bin/bash
else
    docker compose -f services/docker-compose.yml up
fi