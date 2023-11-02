ARG BASE_IMAGE

FROM $BASE_IMAGE as base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG ROS_DISTRO

# Install apt packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  git \
  ssh \
  wget \
  cmake \
  ccache \
  curl \
  gnupg \
  lsb-release \
  ninja-build \
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* "$HOME"/.cache

# Add GitHub to known hosts for private repositories
RUN mkdir -p ~/.ssh \
  && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Copy files
COPY setup-dev-env.sh ansible-galaxy-requirements.yaml amd64.env arm64.env /autoware/
COPY ansible/ /autoware/ansible/
WORKDIR /autoware

# Set up development environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module base openadk \
  && pip uninstall -y ansible ansible-core \
  && pip install vcstool gdown \
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* "$HOME"/.cache \
  && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" > /etc/bash.bashrc

# Create entrypoint
CMD ["/bin/bash"]

FROM base as devel
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG ROS_DISTRO

# Set up development environment
RUN --mount=type=ssh \
  ./setup-dev-env.sh -y --module all openadk --no-cuda-drivers --devel \
  && pip uninstall -y ansible ansible-core \
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* "$HOME"/.cache \
  && find / -name 'libcu*.a' -delete \
  && find / -name 'libnv*.a' -delete 

# Copy repository files
COPY autoware.repos /autoware/

# Install rosdep dependencies
RUN --mount=type=ssh \
  mkdir src \
  && vcs import src < autoware.repos \
  && apt update \
  && rosdep update \
  && DEBIAN_FRONTEND=noninteractive rosdep install -y --ignore-src --from-paths src --rosdistro "$ROS_DISTRO" \
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* "$HOME"/.cache

# Create entrypoint
CMD ["/bin/bash"]

FROM devel as prebuilt
#TODO: test without ninja and ccache
ENV CMAKE_GENERATOR=Ninja
ENV CCACHE_DIR=/ccache

# Build and change permission for runtime data conversion
RUN source /opt/ros/"$ROS_DISTRO"/setup.bash \
  && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --cmake-args \
    " -Wno-dev" \
    " --no-warn-unused-cli" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  && find /autoware/install -type d -exec chmod 777 {} \; \
  && echo "source /autoware/install/setup.bash" > /etc/bash.bashrc

# Create entrypoint
CMD ["/bin/bash"]