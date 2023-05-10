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
export services_use_sim_time
export services_ros_domain_id

# download and unzip sample map for planning simulation
if [ ! -d "/var/tmp/autoware_map/sample-map-planning" ]; then
    mkdir -p /var/tmp/autoware_map
    gdown -O /var/tmp/autoware_map/ 'https://docs.google.com/uc?export=download&id=1499_nsbUbIeturZaDj7jhUownh5fvXHd'
    unzip -d /var/tmp/autoware_map /var/tmp/autoware_map/sample-map-planning.zip
    rm -f /var/tmp/autoware_map/sample-map-planning.zip
fi

# download sample map for replay simulation
if [ ! -d "/var/tmp/autoware_map/sample-map-rosbag" ]; then
    mkdir -p /var/tmp/autoware_map
    gdown -O /var/tmp/autoware_map/ 'https://docs.google.com/uc?export=download&id=1A-8BvYRX3DhSzkAnOcGWFw5T30xTlwZI'
    unzip -d /var/tmp/autoware_map/ /var/tmp/autoware_map/sample-map-rosbag.zip
    rm -f /var/tmp/autoware_map/sample-map-rosbag.zip
fi

# download sample rosbag for replay simulation
if [ ! -d "/var/tmp/autoware_map/sample-rosbag" ]; then
    mkdir -p /var/tmp/autoware_map
    gdown -O /var/tmp/autoware_map/ 'https://docs.google.com/uc?export=download&id=1VnwJx9tI3kI_cTLzP61ktuAJ1ChgygpG'
    unzip -d /var/tmp/autoware_map/ /var/tmp/autoware_map/sample-rosbag.zip
    rm -f /var/tmp/autoware_map/sample-rosbag.zip
fi

# # run awf runtime container(s)
if [ "$option_monolithic" = "true" ]; then
    docker run -it --rm --privileged --net=host --runtime nvidia -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix/:/tmp/.X11-unix -v $HOME/autoware_map:/autoware_map \
    ghcr.io/autowarefoundation/autoware-openadk:all-humble-latest-runtime /bin/bash
else
    docker compose -f services/docker-compose.yml up
fi