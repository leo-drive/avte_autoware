ARG PLATFORM
ARG ROS_DISTRO
FROM ghcr.io/autowarefoundation/autoware-openadk:base-${ROS_DISTRO}-${PLATFORM} as base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PLATFORM
ARG ROS_DISTRO

# Copy install folder from prebuilt
FROM ghcr.io/autowarefoundation/autoware-openadk:prebuilt-${ROS_DISTRO}-${PLATFORM} as prebuilt
FROM base as main-perception
COPY --from=prebuilt /autoware/install/ /autoware/install/

COPY autoware.repos /autoware/

# Set up runtime environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module main-perception --no-cuda-drivers openadk \
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

# Copy bash aliases
COPY docker/autoware-openadk/services/main-perception/.bash_aliases /root/.bash_aliases

# Copy launch file
COPY docker/autoware-openadk/services/main-perception/launch/ /launch/

RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc

# Create entrypoint
COPY docker/autoware-openadk/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]