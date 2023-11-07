ARG PLATFORM
ARG ROS_DISTRO
FROM ghcr.io/autowarefoundation/autoware-openadk:base-${ROS_DISTRO}-${PLATFORM} as simulator

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PLATFORM
ARG ROS_DISTRO

COPY simulator.repos /autoware/

# Set up runtime environment
RUN --mount=type=ssh \
  mkdir src \
  && vcs import src < simulator.repos \
  && vcs import src < /autoware/src/simulator/scenario_simulator/dependency_humble.repos \
  && apt update \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --rosdistro "$ROS_DISTRO" --ignore-src --from-paths src \
  && source /opt/ros/"$ROS_DISTRO"/setup.bash \
  && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --cmake-args \
    " -Wno-dev" \
    " --no-warn-unused-cli" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  && find /autoware/install -type d -exec chmod 777 {} \; \
  && echo "source /autoware/install/setup.bash" > /etc/bash.bashrc \
  # Remove unnecessary files
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* "$HOME"/.cache \
  && find /usr/lib/$PLATFORM-linux-gnu -name "*.a" -type f -delete \
  && find / -name "*.o" -type f -delete \
  && find / -name "*.h" -type f -delete \
  && find / -name "*.hpp" -type f -delete \
  && rm -rf /autoware/src /autoware/ansible /autoware/simulator.repos \
    /root/.local/pipx /opt/ros/humble/include /etc/apt/sources.list.d/cuda*.list \
    /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/nvidia-docker.list \
    /usr/include /usr/share/doc /usr/lib/gcc /usr/lib/jvm /usr/lib/llvm*

# Bugfix rviz2 black-screen problem with some nvidia drivers: https://github.com/ros2/rviz/issues/948
RUN apt update && apt install -y software-properties-common && add-apt-repository ppa:kisak/kisak-mesa && apt install -y \
  libegl-mesa0 libegl1-mesa-dev libgbm-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri libglapi-mesa libglx-mesa0

# Copy bash aliases
COPY docker/autoware-openadk/services/simulator/.bash_aliases /root/.bash_aliases

# Copy launch file
COPY docker/autoware-openadk/services/simulator/launch/ /launch/

RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc

# Create entrypoint
COPY docker/autoware-openadk/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]