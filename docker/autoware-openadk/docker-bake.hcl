group "default" {
  targets = ["base", "devel", "prebuilt"]
}

// For docker/metadata-action
target "docker-metadata-action-base" {}
target "docker-metadata-action-devel" {}
target "docker-metadata-action-prebuilt" {}
target "docker-metadata-action-simulator" {}
target "docker-metadata-action-planning-control" {}
target "docker-metadata-action-visualizer" {}

target "base" {
  inherits = ["docker-metadata-action-base"]
  dockerfile = "docker/autoware-openadk/base/Dockerfile"
  target = "base"
}

target "devel" {
  inherits = ["docker-metadata-action-devel"]
  dockerfile = "docker/autoware-openadk/base/Dockerfile"
  target = "devel"
}

target "prebuilt" {
  inherits = ["docker-metadata-action-prebuilt"]
  dockerfile = "docker/autoware-openadk/base/Dockerfile"
  target = "prebuilt"
}

target "planning-control" {
  inherits = ["docker-metadata-action-planning-control"]
  dockerfile = "docker/autoware-openadk/services/planning-control/Dockerfile"
  target = "planning-control"
}

target "simulator" {
  inherits = ["docker-metadata-action-simulator"]
  dockerfile = "docker/autoware-openadk/services/simulator/Dockerfile"
  target = "simulator"
}

target "visualizer" {
  inherits = ["docker-metadata-action-visualizer"]
  dockerfile = "docker/autoware-openadk/services/visualizer/Dockerfile"
  target = "visualizer"
}