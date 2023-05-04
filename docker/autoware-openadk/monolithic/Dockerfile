FROM ghcr.io/autowarefoundation/autoware-openadk:base-humble-latest

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PLATFORM
ARG ROS_DISTRO

# Copy bash aliases
COPY docker/autoware-openadk/etc/.bash_aliases /root/.bash_aliases

# Copy install folder from prebuilt
COPY --from=ghcr.io/autowarefoundation/autoware-openadk:prebuilt-humble-latest /autoware/install/ /autoware/install/

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

# Create entrypoint
# hadolint ignore=DL3059
RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc
CMD ["/bin/bash"]