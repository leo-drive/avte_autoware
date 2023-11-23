#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")
WORKSPACE_ROOT="$SCRIPT_DIR/../../"

# Parse arguments
option_no_runtime=false
args=()
while [ "$1" != "" ]; do
    case "$1" in
    --platform)
        option_platform="$2"
        shift
        ;;
    --prebuilt-only)
        option_no_runtime=true
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

# https://github.com/docker/buildx/issues/484
export BUILDKIT_STEP_LOG_MAX_SIZE=10000000

# Export variables
export platform
export rosdistro

set -x
# Build base images
docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/docker-bake.hcl" \
    --set "*.context=$WORKSPACE_ROOT" \
    --set "*.ssh=default" \
    --set "*.platform=$platform" \
    --set "*.args.PLATFORM=$platform" \
    --set "*.args.ROS_DISTRO=$rosdistro" \
    --set "*.args.BASE_IMAGE=$base_image" \
    --set "base.tags=ghcr.io/autowarefoundation/autoware-openadk:base-$rosdistro-$platform" \
    --set "devel.tags=ghcr.io/autowarefoundation/autoware-openadk:devel-$rosdistro-$platform" \
    --set "prebuilt.tags=ghcr.io/autowarefoundation/autoware-openadk:prebuilt-$rosdistro-$platform"

# Set build targets
if [ "$option_no_runtime" = "false" ]; then
    docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/docker-bake.hcl" \
        --set "*.context=$WORKSPACE_ROOT" \
        --set "*.ssh=default" \
        --set "*.platform=$platform" \
        --set "*.args.PLATFORM=$platform" \
        --set "*.args.ROS_DISTRO=$rosdistro" \
        --set "*.args.BASE_IMAGE=$base_image" \
        --set "runtime-planning-control.tags=ghcr.io/autowarefoundation/autoware-openadk:runtime-before-planning-$rosdistro-$platform" \
        runtime-planning-control
fi
set +x