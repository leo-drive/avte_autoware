#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")
WORKSPACE_ROOT="$SCRIPT_DIR/../../"


# https://github.com/docker/buildx/issues/484
export BUILDKIT_STEP_LOG_MAX_SIZE=10000000

source "$WORKSPACE_ROOT/amd64.env"
export rosdistro

set -x
# Build base images
docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/docker-bake.hcl" \
    --set "*.context=$WORKSPACE_ROOT" \
    --set "*.ssh=default" \
    --set "*.platform=aarch64" \
    --set "*.args.PLATFORM=aarch64" \
    --set "*.args.ROS_DISTRO=$rosdistro" \
    --set "*.args.BASE_IMAGE=$base_image" \
    --set "base.tags=ghcr.io/autowarefoundation/autoware-openadk:base-$rosdistro-aarch64" \
    --set "devel.tags=ghcr.io/autowarefoundation/autoware-openadk:devel-$rosdistro-aarch64" \
    --set "prebuilt.tags=ghcr.io/autowarefoundation/autoware-openadk:prebuilt-$rosdistro-aarch64"

# Build runtime images
docker buildx bake --load --progress=plain -f "$SCRIPT_DIR/docker-bake.hcl" \
    --set "*.context=$WORKSPACE_ROOT" \
    --set "*.ssh=default" \
    --set "*.platform=aarch64" \
    --set "*.args.PLATFORM=aarch64" \
    --set "*.args.ROS_DISTRO=$rosdistro" \
    --set "*.args.BASE_IMAGE=$base_image" \
    --set "planning-control.tags=ghcr.io/autowarefoundation/autoware-openadk:ces-planning-before-$platform" \
    --set "simulator.tags=ghcr.io/autowarefoundation/autoware-openadk:ces-simulator-aarch64" \
    planning-control simulator

#TO-DO
# build visualization container for x86
# upload containers via github actions
set +x