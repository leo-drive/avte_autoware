group "default" {
  targets = ["devel", "runtime"]
}

// For docker/metadata-action
target "docker-metadata-action-devel" {}
target "docker-metadata-action-runtime" {}

target "devel" {
  inherits = ["docker-metadata-action-devel"]
  dockerfile = "docker/autoware-openadk/Dockerfile"
  target = "devel"
}

target "runtime" {
  inherits = ["docker-metadata-action-runtime"]
  dockerfile = "docker/autoware-openadk/Dockerfile"
  target = "runtime"
}
