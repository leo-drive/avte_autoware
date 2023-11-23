function download_planning_map() {
    if [ ! -f ~/autoware_map/sample-map-planning.zip ]; then
        gdown -O ~/autoware_map/ 'https://docs.google.com/uc?export=download&id=1499_nsbUbIeturZaDj7jhUownh5fvXHd'
        unzip -d ~/autoware_map ~/autoware_map/sample-map-planning.zip
    fi
}

alias awf-launch-planning-sim='download_planning_map&&ros2 launch autoware_launch planning_simulator.launch.xml map_path:=$HOME/autoware_map/sample-map-planning vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'


# planning-control launch
alias awf-launch-with-sample-map='ros2 launch /launch/planning-control.launch.xml map_path:=$HOME/autoware_map/sample-map-planning vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'