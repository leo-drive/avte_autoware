# scenario planning simulator
alias awf-launch-planning-scenario-sim='ros2 launch scenario_test_runner scenario_test_runner.launch.py architecture_type:=awf/universe record:=false scenario:=/autoware/scenario/yield_maneuver_demo.yaml sensor_model:=sample_sensor_kit vehicle_model:=sample_vehicle map_path:=/autoware/scenario/map/'

# rosbag replay simulator
alias awf-launch-sample-rosbag-sim='ros2 launch autoware_launch logging_simulator.launch.xml map_path:=/autoware/map/sample-map-rosbag vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'

# vanilla autoware launch
alias awf-launch-autoware='ros2 launch autoware_launch autoware.launch.xml map_path:=/autoware/map/sample-map-rosbag/ vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'
