// group "default" {
//   targets = ["base", "devel", "prebuilt", "monolithic", "main-perception", "planning-control"]
// }
group "default" {
  targets = ["base", "devel", "prebuilt", "monolithic"]
}


// For docker/metadata-action
target "docker-metadata-action-base" {}
target "docker-metadata-action-devel" {}
target "docker-metadata-action-prebuilt" {}
target "docker-metadata-action-monolithic" {}
target "docker-metadata-action-main-perception" {}
target "docker-metadata-action-planning-control" {}

target "base" {
  inherits = ["docker-metadata-action-base"]
  dockerfile = "docker/autoware-openadk/Dockerfile"
  target = "base"
}

target "devel" {
  inherits = ["docker-metadata-action-devel"]
  dockerfile = "docker/autoware-openadk/Dockerfile"
  target = "devel"
}

target "prebuilt" {
  inherits = ["docker-metadata-action-prebuilt"]
  dockerfile = "docker/autoware-openadk/Dockerfile"
  target = "prebuilt"
}

target "monolithic" {
  inherits = ["docker-metadata-action-monolithic"]
  dockerfile = "docker/autoware-openadk/Dockerfile"
  target = "monolithic"
}

target "main-perception" {
  inherits = ["docker-metadata-action-main-perception"]
  dockerfile = "docker/autoware-openadk/services/main-perception/Dockerfile"
  target = "main-perception"
}

target "planning-control" {
  inherits = ["docker-metadata-action-planning-control"]
  dockerfile = "docker/autoware-openadk/services/planning-control/Dockerfile"
  target = "planning-control"
}
