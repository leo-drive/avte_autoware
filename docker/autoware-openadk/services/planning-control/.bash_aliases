# run planning container with simulator on
alias run-planning-module='ros2 launch autoware_launch planning_simulator.launch.xml map_path:=/autoware/scenario-sim/map/ vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit scenario_simulation:=true use_foa:=false'