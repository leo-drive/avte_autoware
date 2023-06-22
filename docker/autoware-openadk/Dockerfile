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
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Copy files
COPY setup-dev-env.sh ansible-galaxy-requirements.yaml amd64.env arm64.env /autoware/
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

# START-devel image
# hadolint ignore=DL3006
FROM base as devel
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ROS_DISTRO

# Set up development environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module all openadk \
  && pip uninstall -y ansible ansible-core \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  "$HOME"/.cache

# Create entrypoint
# hadolint ignore=DL3059
CMD ["/bin/bash"]

# START-prebuilt image
# hadolint ignore=DL3006
FROM devel as prebuilt
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ROS_DISTRO

COPY autoware.repos simulator.repos /autoware/

RUN --mount=type=ssh \
  mkdir src \
  && vcs import src < autoware.repos \
  && vcs import src < simulator.repos \
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

# Copy bash aliases
COPY docker/autoware-openadk/etc/.bash_aliases /root/.bash_aliases
COPY autoware.repos /autoware/

# Copy install folder from prebuilt
COPY --from=prebuilt /autoware/install/ /autoware/install/

# Set up runtime environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module all --no-cuda-drivers --runtime openadk \
  && pip uninstall -y ansible ansible-core \
  && mkdir src \
  && vcs import src < autoware.repos \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --ignore-src --from-paths src --rosdistro "$ROS_DISTRO" \ 
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

# Register Vulkan GPU vendors
RUN curl https://gitlab.com/nvidia/container-images/vulkan/raw/dc389b0445c788901fda1d85be96fd1cb9410164/nvidia_icd.json -o /etc/vulkan/icd.d/nvidia_icd.json \
  && chmod 644 /etc/vulkan/icd.d/nvidia_icd.json
RUN curl https://gitlab.com/nvidia/container-images/opengl/raw/5191cf205d3e4bb1150091f9464499b076104354/glvnd/runtime/10_nvidia.json -o /etc/glvnd/egl_vendor.d/10_nvidia.json \
  && chmod 644 /etc/glvnd/egl_vendor.d/10_nvidia.json

# Register OpenCL GPU vendors
RUN mkdir -p /etc/OpenCL/vendors \
  && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd \
  && chmod 644 /etc/OpenCL/vendors/nvidia.icd

# Create entrypoint
# hadolint ignore=DL3059
RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc
CMD ["/bin/bash"]