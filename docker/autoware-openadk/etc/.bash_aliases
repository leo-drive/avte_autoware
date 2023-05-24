alias awf-launch-sample-planning-sim='ros2 launch autoware_launch planning_simulator.launch.xml map_path:=/autoware_map/sample-map-planning vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'

alias awf-launch-sample-replay-sim='ros2 launch autoware_launch logging_simulator.launch.xml map_path:=/autoware_map/sample-map-rosbag vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'

alias awf-replay-sample-rosbag='ros2 bag play /autoware_map/sample-rosbag/sample.db3 -r 0.8 -s sqlite3'