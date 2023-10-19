## TO-DO
- [ ] Create new ros2 launch files for docker images
- [ ] Create new docker-compose files for docker images
- [ ] Rosdep installs all dependencies not only exec_depend's. It should be fixed to install only exec_depend's.
- [ ] We can use DPDK for DDS communication to improve performance and reduce latency on distributed architectures. https://ieeexplore.ieee.org/document/10074877

# Hints and Tips
- rosdep install --ignore-src --dependency-types exec --from-paths src --reinstall --simulate 
- Use the --squash option when building images to reduce the size of the image layers.
- Always run an NTP client on the Docker host and within each container process and sync them all to the same NTP server. If you use swarm services, also ensure that each Docker node syncs its clocks to the same time source as the containers.
- Best practices documentation
    - https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
    - https://docs.docker.com/develop/dev-best-practices/