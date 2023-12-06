ARG BASE_IMAGE
ARG ROS_DISTRO

FROM $BASE_IMAGE as visualizer-base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG ROS_DISTRO

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  ssh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Copy files
COPY setup-dev-env.sh ansible-galaxy-requirements.yaml /autoware/
COPY ansible/ /autoware/ansible/
WORKDIR /autoware

# Add GitHub to known hosts for private repositories
RUN mkdir -p ~/.ssh \
  && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Set up development environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module base openadk --runtime \
  && pip uninstall -y ansible ansible-core \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

# Copy install folder from prebuilt
FROM ghcr.io/autowarefoundation/autoware-openadk:prebuilt-${ROS_DISTRO}-aarch64 as prebuilt
FROM visualizer-base as visualizer
COPY --from=prebuilt /autoware/install/ /autoware/install/

# Bugfix rviz2 black-screen problem with some nvidia drivers: https://github.com/ros2/rviz/issues/948
RUN apt update && apt install -y software-properties-common && add-apt-repository ppa:kisak/kisak-mesa && apt install -y \
  libegl-mesa0 libegl1-mesa-dev libgbm-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri libglapi-mesa libglx-mesa0 ros-humble-rviz2

# Create entrypoint
COPY docker/autoware-openadk/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

# Copy simulation files
RUN mkdir -p /autoware/scenario-sim
COPY docker/autoware-openadk/etc/simulation/ /autoware/scenario-sim/

# Copy bash aliases
COPY docker/autoware-openadk/services/planning-control/.bash_aliases /root/.bash_aliases

# Create entrypoint
RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]