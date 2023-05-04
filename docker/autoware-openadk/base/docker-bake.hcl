group "default" {
  targets = ["base", "prebuilt"]
}

// For docker/metadata-action
target "docker-metadata-action-base" {}
target "docker-metadata-action-prebuilt" {}

target "base" {
  inherits = ["docker-metadata-action-base"]
  dockerfile = "docker/autoware-openadk/base/Dockerfile"
  target = "base"
}

target "prebuilt" {
  inherits = ["docker-metadata-action-prebuilt"]
  dockerfile = "docker/autoware-openadk/base/Dockerfile"
  target = "prebuilt"
}
