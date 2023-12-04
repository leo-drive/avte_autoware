ARG PLATFORM
ARG ROS_DISTRO
FROM ghcr.io/autowarefoundation/autoware-openadk:base-${ROS_DISTRO}-${PLATFORM} as base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PLATFORM
ARG ROS_DISTRO

# Copy launch file
COPY docker/autoware-openadk/services/planning-control/launch/ /launch/

# Copy install folder from prebuilt
FROM ghcr.io/autowarefoundation/autoware-openadk:prebuilt-${ROS_DISTRO}-${PLATFORM} as prebuilt
FROM base as planning-control
COPY --from=prebuilt /autoware/install/ /autoware/install/
COPY autoware.repos simulator.repos /autoware/

# Set up runtime environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module planning-control --runtime openadk \
  && pip uninstall -y ansible ansible-core \
  && mkdir src \
  && vcs import src < simulator.repos \
  && vcs import src < autoware.repos \
  && apt-get update \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --rosdistro "$ROS_DISTRO" --ignore-src --from-paths src \
  # Remove unnecessary files
  && apt-get clean \
  && find /usr/lib/$PLATFORM-linux-gnu -name "*.a" -type f -delete \
  && find / -name "*.o" -type f -delete \
  && find / -name "*.h" -type f -delete \
  && find / -name "*.hpp" -type f -delete \
  && rm -rf /var/lib/apt/lists/* \
  /autoware/src \
  /autoware/ansible \
  /autoware/autoware.repos \
  /root/.local/pipx \
  /opt/ros/humble/include \
  /etc/apt/sources.list.d/cuda*.list \
  /etc/apt/sources.list.d/docker.list \
  /etc/apt/sources.list.d/nvidia-docker.list \
  "$HOME"/.cache \
  /usr/include \
  /usr/share/doc \ 
  /usr/lib/gcc \
  /usr/lib/jvm \
  /usr/lib/llvm*

# Bugfix rviz2 black-screen problem with some nvidia drivers: https://github.com/ros2/rviz/issues/948
RUN apt update && apt install -y software-properties-common && add-apt-repository ppa:kisak/kisak-mesa && apt install -y \
  libegl-mesa0 libegl1-mesa-dev libgbm-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri libglapi-mesa libglx-mesa0

# Create entrypoint
# hadolint ignore=DL3059
COPY docker/autoware-openadk/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

# Copy simulation files
RUN mkdir -p /autoware/scenario-sim
COPY docker/autoware-openadk/etc/simulation/ /autoware/scenario-sim/

# Copy bash aliases
COPY docker/autoware-openadk/etc/.bash_aliases /root/.bash_aliases

# Create entrypoint
# hadolint ignore=DL3059
RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]