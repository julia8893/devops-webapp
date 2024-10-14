terraform {
 required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "nextjs-app" {
  name          = "julia8893/nextjs-app:1.0"
  keep_locally  = false
}

resource "docker_container" "nextjs-container" {
  image = docker_image.nextjs-app.image_id
  name = "terraform_test"

  ports {
    internal = 3000
    external = 3000
  }
}