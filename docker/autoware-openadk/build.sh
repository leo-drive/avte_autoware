#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")
WORKSPACE_ROOT="$SCRIPT_DIR/../../"

# Parse arguments
args=()
while [ "$1" != "" ]; do
    case "$1" in
    --platform)
        option_platform="$2"
        shift
        ;;
    --no-devel)
        option_no_devel=true
        ;;
    *)
        args+=("$1")
        ;;
    esac
    shift
done

# Set platform
if [ -n "$option_platform" ]; then
    platform="$option_platform"
else
    platform="x86_64"
    if [ "$(uname -m)" = "aarch64" ]; then
        platform="aarch64"
    fi
fi

# Load platform specific dependencies
source "$WORKSPACE_ROOT/amd64.env"
if [ "$platform" = "aarch64" ]; then
    source "$WORKSPACE_ROOT/arm64.env"
fi

# Set build targets
if [ "$option_no_devel" = "true" ]; then
    targets=("runtime")
else
    # default target includes devel and runtime
    targets=()
fi

# https://github.com/docker/buildx/issues/484
export BUILDKIT_STEP_LOG_MAX_SIZE=10000000

# Export variables
export platform
export rosdistro

set -x
# Build base images
docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/base/docker-bake.hcl" \
    --set "*.context=$WORKSPACE_ROOT" \
    --set "*.ssh=default" \
    --set "*.platform=$platform" \
    --set "*.args.PLATFORM=$platform" \
    --set "*.args.ROS_DISTRO=$rosdistro" \
    --set "*.args.BASE_IMAGE=$base_image" \
    --set "base.tags=ghcr.io/autowarefoundation/autoware-openadk:base-$rosdistro-latest" \
    --set "prebuilt.tags=ghcr.io/autowarefoundation/autoware-openadk:prebuilt-$rosdistro-latest" \
    "${targets[@]}"

# Build monolithic runtime image
docker build -t ghcr.io/autowarefoundation/autoware-openadk:runtime-monolithic-$rosdistro-latest \
    --build-arg PLATFORM="$platform" \
    --build-arg ROS_DISTRO="$rosdistro" \
    -f "$SCRIPT_DIR/monolithic/Dockerfile" "$WORKSPACE_ROOT"

# Build services
docker compose -f "$SCRIPT_DIR/services/docker-compose.yml" build

set +x