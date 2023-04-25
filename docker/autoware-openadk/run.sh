#!/bin/sh
# This script is used to run Autoware ADK monolithic in a Docker container.

# download and unzip sample map for planning simulation
mkdir -p ~/autoware_map
gdown -O ~/autoware_map/ 'https://docs.google.com/uc?export=download&id=1499_nsbUbIeturZaDj7jhUownh5fvXHd'
unzip -d ~/autoware_map ~/autoware_map/sample-map-planning.zip
rm ~/autoware_map/sample-map-planning.zip

# download sample rosbag and map for replay simulation
gdown -O ~/autoware_map/ 'https://docs.google.com/uc?export=download&id=1A-8BvYRX3DhSzkAnOcGWFw5T30xTlwZI'
unzip -d ~/autoware_map/ ~/autoware_map/sample-map-rosbag.zip
rm ~/autoware_map/sample-map-rosbag.zip
gdown -O ~/autoware_map/ 'https://docs.google.com/uc?export=download&id=1VnwJx9tI3kI_cTLzP61ktuAJ1ChgygpG'
unzip -d ~/autoware_map/ ~/autoware_map/sample-rosbag.zip
rm ~/autoware_map/sample-rosbag.zip

# run Autoware ADK monolithic in a Docker container
docker run -it --rm --privileged --net=host --runtime nvidia -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix/:/tmp/.X11-unix -v $HOME/autoware_map:/autoware_map \
    ghcr.io/autowarefoundation/autoware-openadk:all-humble-latest-runtime /bin/bash