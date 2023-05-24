## TO-DO
- [ ] We can use DPDK for DDS communication to improve performance and reduce latency on distributed architectures. https://ieeexplore.ieee.org/document/10074877
- [ ] Build only the required packages for the target module in builder stage
- [ ] Run rosdep only for the required packages for the target module in builder stage
- [ ] Try https://github.com/slimtoolkit/slim to reduce the size of the images
- [ ] Create new ros2 launch files for docker images
- [ ] Create new docker-compose files for docker images
- [ ] Rosdep installs all dependencies not only exec_depend's. It should be fixed to install only exec_depend's.
- [ ] NVIDIA CUDA images can be used as base images for faster and more efficient builds. https://hub.docker.com/r/nvidia/cuda
- [ ] Are we going to use Foxglove ?

# Hints and Tips
- rosdep install --ignore-src --dependency-types exec --from-paths src --reinstall --simulate 
- Use the --no-cache option when building images to ensure that you are always working with the latest versions of packages.
- Use the --squash option when building images to reduce the size of the image layers.
- Use the --rm option when building images to ensure that you are not leaving behind any intermediate containers.
- Use "RUN --mount=type=bind instruction" instead of COPY as it is more efficient. 
- Always run an NTP client on the Docker host and within each container process and sync them all to the same NTP server. If you use swarm services, also ensure that each Docker node syncs its clocks to the same time source as the containers.
- RESOURCES
    - https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
    - https://docs.docker.com/develop/dev-best-practices/