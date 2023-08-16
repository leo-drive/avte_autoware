ARG BASE_IMAGE

# hadolint ignore=DL3006
# START-base image
FROM $BASE_IMAGE as base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ROS_DISTRO

# Install apt packages
# hadolint ignore=DL3008
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  git \
  ssh \
  python3.10-venv \
  && mkdir -p /autoware/ansible/playbooks \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Copy files
COPY setup-dev-env.sh ansible-galaxy-requirements.yaml amd64.env arm64.env /autoware/
COPY ansible/galaxy.yml /autoware/ansible/galaxy.yml
COPY ansible/COLCON_IGNORE /autoware/ansible/COLCON_IGNORE
COPY ansible/playbooks/base.yaml /autoware/ansible/playbooks/base.yaml
COPY ansible/roles/base /autoware/ansible/roles/base

# Workdir
WORKDIR /autoware
RUN ls /autoware

# # Add GitHub to known hosts for private repositories
RUN mkdir -p ~/.ssh \
  && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Set up development environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y base --runtime \
  && pip uninstall -y ansible ansible-core \
  && pip install vcstool \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

# Create entrypoint
# hadolint ignore=DL3059
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" > /etc/bash.bashrc
CMD ["/bin/bash"]

# START-devel image
# hadolint ignore=DL3006
FROM base as pre-devel
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ROS_DISTRO

# Set up planning-control
COPY ansible/playbooks/planning_control.yaml /autoware/ansible/playbooks/planning_control.yaml
COPY ansible/roles/planning_control /autoware/ansible/roles/planning_control
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y planning_control \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

# Set up perception-localization
COPY ansible/playbooks/perception_localization.yaml /autoware/ansible/playbooks/perception_localization.yaml
COPY ansible/roles/perception_localization /autoware/ansible/roles/perception_localization
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y perception_localization \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

# Checkout latest source code and install rosdep dependencies
COPY autoware.repos /autoware/
RUN --mount=type=ssh \
  mkdir src \
  && vcs import src < autoware.repos \
  && apt-get update \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --ignore-src --from-paths src --rosdistro "$ROS_DISTRO" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

CMD ["/bin/bash"]

FROM pre-devel as devel
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set up development tooling
COPY ansible/playbooks/devel.yaml /autoware/ansible/playbooks/devel.yaml
COPY ansible/roles/devel /autoware/ansible/roles/devel
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y devel \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

# Create entrypoint
# hadolint ignore=DL3059
CMD ["/bin/bash"]

# START-prebuilt image
# hadolint ignore=DL3006
FROM pre-devel as prebuilt
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ROS_DISTRO

# Build Autoware from source and install
RUN --mount=type=ssh source /opt/ros/"$ROS_DISTRO"/setup.bash \
  && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release \
  && find /autoware/install -type d -exec chmod 777 {} \;

RUN chmod -R 777 /autoware/install/
RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc

# Create entrypoint
# hadolint ignore=DL3059
CMD ["/bin/bash"]

# START-monolithic image
FROM base as monolithic
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PLATFORM
ARG ROS_DISTRO

# Set up planning-control
COPY ansible/playbooks/planning_control.yaml /autoware/ansible/playbooks/planning_control.yaml
COPY ansible/roles/planning_control /autoware/ansible/roles/planning_control
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --runtime planning_control \
  && apt-get clean \
  && find /usr/lib/$PLATFORM-linux-gnu -name "*.a" -type f -delete \
  && find / -name "*.o" -type f -delete \
  && find / -name "*.h" -type f -delete \
  && find / -name "*.hpp" -type f -delete \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

# Set up perception-localization
COPY ansible/playbooks/perception_localization.yaml /autoware/ansible/playbooks/perception_localization.yaml
COPY ansible/roles/perception_localization /autoware/ansible/roles/perception_localization
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --runtime --no-cuda-drivers perception_localization \
  && apt-get clean \
  && find /usr/lib/$PLATFORM-linux-gnu -name "*.a" -type f -delete \
  && find / -name "*.o" -type f -delete \
  && find / -name "*.h" -type f -delete \
  && find / -name "*.hpp" -type f -delete \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

# Install rosdep dependencies
COPY autoware.repos /autoware/
COPY --from=prebuilt /autoware/install/ /autoware/install/
RUN --mount=type=ssh \
  mkdir src \
  && vcs import src < autoware.repos \
  && apt-get update \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --ignore-src --from-paths src --rosdistro "$ROS_DISTRO" \
  && apt-get clean \
  && find /usr/lib/$PLATFORM-linux-gnu -name "*.a" -type f -delete \
  && find / -name "*.o" -type f -delete \
  && find / -name "*.h" -type f -delete \
  && find / -name "*.hpp" -type f -delete \
  && rm -rf /var/lib/apt/lists/* \
  /autoware/src \
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

# Copy bash aliases
COPY docker/autoware-openadk/etc/.bash_aliases /root/.bash_aliases

# # DEBUG - Copy launch files of modules
# COPY docker/autoware-openadk/services/main-perception/launch/ /launch/
# COPY docker/autoware-openadk/services/planning-control/launch/ /launch/

# # DEBUG - Create entrypoint as ros2 not found in PATHS
# COPY docker/autoware-openadk/etc/ros_entrypoint.sh /ros_entrypoint.sh
# RUN chmod +x /ros_entrypoint.sh

# RUN source /usr/share/bash-completion/completions/git
# RUN source /opt/ros/humble/setup.bash
# RUN source /autoware/install/setup.bash

# RUN echo "source /usr/share/bash-completion/completions/git" >> /root/.profile \
#   && echo "source /opt/ros/humble/setup.bash" >> /root/.profile \
#   && echo "source /autoware/install/setup.bash" >> /root/.profile

# ENTRYPOINT ["/ros_entrypoint.sh"]
# CMD ["bash"]

# Create entrypoint
# hadolint ignore=DL3059
RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc
CMD ["/bin/bash"]