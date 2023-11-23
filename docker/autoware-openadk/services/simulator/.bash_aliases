# planning simulator
alias awf-launch-rviz='rviz2 -d $(find-pkg-share autoware_launch)/rviz/autoware.rviz'

# rosbag replay simulator
alias awf-launch-sample-rosbag-sim='ros2 launch autoware_launch logging_simulator.launch.xml map_path:=/autoware/map/sample-map-rosbag vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'
