# planning-control launch
alias awf-launch-planning-control='ros2 launch /launch/planning-control.launch.xml map_path:=/autoware/map/ vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'

# vanilla autoware launch
alias awf-launch-autoware='ros2 launch autoware_launch autoware.launch.xml map_path:=/autoware/map/sample-map-rosbag/ vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'