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
    --module)
        option_module="$2"
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
    platform="linux/amd64"
    if [ "$(uname -m)" = "aarch64" ]; then
        platform="linux/arm64"
    fi
fi

# Load platform specific dependencies
source "$WORKSPACE_ROOT/amd64.env"
if [ "$platform" = "linux/arm64" ]; then
    source "$WORKSPACE_ROOT/arm64.env"
fi

# Set default module if not specified
if [ -z "$option_module" ]; then
    option_module="all"
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

set -x
docker buildx bake --no-cache --load --progress=plain -f "$SCRIPT_DIR/docker-bake.hcl" \
    --set "*.context=$WORKSPACE_ROOT" \
    --set "*.ssh=default" \
    --set "*.platform=$platform" \
    --set "*.args.ROS_DISTRO=$rosdistro" \
    --set "*.args.BASE_IMAGE=$base_image" \
    --set "*.args.PREBUILT_BASE_IMAGE=$prebuilt_base_image" \
    --set "*.args.MODULE=$option_module" \
    --set "devel.tags=ghcr.io/autowarefoundation/autoware-openadk:$rosdistro-latest-devel-local" \
    --set "prebuilt.tags=ghcr.io/autowarefoundation/autoware-openadk:$rosdistro-latest-runtime-local" \
    "${targets[@]}"

# Remove intermediate images
docker image prune --filter label=stage=builder
set +x
