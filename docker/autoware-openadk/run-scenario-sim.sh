#!/usr/bin/env bash

set -e

# scenario simulator
docker run -it --net=host -v /dev/shm:/dev/shm  -e ROS_DOMAIN_ID=88 ghcr.io/oguzkaganozt/autoware-openadk:planning-demo-before-ota-aarch64 ros2 launch scenario_test_runner scenario_test_runner.launch.py architecture_type:=awf/universe record:=false scenario:=/autoware/scenario-sim/yield_maneuver_demo.yaml sensor_model:=sample_sensor_kit vehicle_model:=sample_vehicle map_path:=/autoware/scenario-sim/map/


