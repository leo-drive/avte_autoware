ARG BASE_IMAGE

# hadolint ignore=DL3006
FROM $BASE_IMAGE as base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ROS_DISTRO

# Install apt packages
# hadolint ignore=DL3008
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  git \
  ssh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Copy files
COPY autoware.repos setup-dev-env.sh ansible-galaxy-requirements.yaml amd64.env arm64.env /autoware/
COPY ansible/ /autoware/ansible/
WORKDIR /autoware
RUN ls /autoware

# Add GitHub to known hosts for private repositories
RUN mkdir -p ~/.ssh \
  && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Set up development environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module base openadk --runtime \
  && pip uninstall -y ansible ansible-core \
  && pip install vcstool \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

# Create entrypoint
# hadolint ignore=DL3059
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" > /etc/bash.bashrc
CMD ["/bin/bash"]

# hadolint ignore=DL3006
FROM base as prebuilt
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ROS_DISTRO

# Set up development environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module all openadk \
  && pip uninstall -y ansible ansible-core \
  && mkdir src \
  && vcs import src < autoware.repos \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --ignore-src --from-paths src --rosdistro "$ROS_DISTRO" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache \
  /etc/apt/sources.list.d/cuda*.list \
  /etc/apt/sources.list.d/docker.list \
  /etc/apt/sources.list.d/nvidia-docker.list

# Build and change permission for runtime data conversion
RUN source /opt/ros/"$ROS_DISTRO"/setup.bash \
  && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release \
  && find /autoware/install -type d -exec chmod 777 {} \;

# Create entrypoint
# hadolint ignore=DL3059
CMD ["/bin/bash"]