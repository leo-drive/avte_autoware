ARG PLATFORM
ARG ROS_DISTRO
FROM ghcr.io/autowarefoundation/autoware-openadk:base-${ROS_DISTRO}-${PLATFORM} as base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PLATFORM
ARG ROS_DISTRO

# Copy install folder from prebuilt
FROM ghcr.io/autowarefoundation/autoware-openadk:prebuilt-${ROS_DISTRO}-${PLATFORM} as prebuilt
FROM base as planning-control
COPY --from=prebuilt /autoware/install/ /autoware/install/

COPY autoware.repos /autoware/

# Set up runtime environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module planning-control openadk \
  && pip uninstall -y ansible ansible-core \
  && mkdir src \
  && vcs import src < autoware.repos \
  && apt-get update \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --rosdistro "$ROS_DISTRO" --ignore-src --from-paths src \
  # Remove unnecessary files
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* "$HOME"/.cache \
  && find /usr/lib/$PLATFORM-linux-gnu -name "*.a" -type f -delete \
  && find / -name "*.o" -type f -delete \
  && find / -name "*.h" -type f -delete \
  && find / -name "*.hpp" -type f -delete \
  && rm -rf /autoware/src /autoware/ansible /autoware/autoware.repos \
    /root/.local/pipx /opt/ros/humble/include /etc/apt/sources.list.d/cuda*.list \
    /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/nvidia-docker.list \
    /usr/include /usr/share/doc /usr/lib/gcc /usr/lib/jvm /usr/lib/llvm*

# Bugfix rviz2 black-screen problem with some nvidia drivers: https://github.com/ros2/rviz/issues/948
RUN apt update && apt install -y software-properties-common && add-apt-repository ppa:kisak/kisak-mesa && apt install -y \
  libegl-mesa0 libegl1-mesa-dev libgbm-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri libglapi-mesa libglx-mesa0 unzip

# Copy bash aliases
COPY docker/autoware-openadk/services/planning-control/.bash_aliases /root/.bash_aliases

# Copy launch file
COPY docker/autoware-openadk/services/planning-control/launch/ /launch/

RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc

# Create entrypoint
COPY docker/autoware-openadk/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]