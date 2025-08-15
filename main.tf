terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Configuração de rede
resource "docker_network" "app_network" {
  name = "app_network"
}

# Configruação do banco de dados PostgreSQL
resource "docker_volume" "pgdata" {
  name = "pgdata"
}

resource "docker_image" "postgres_image" {
  name = "postgres:15.8"
}

resource "docker_container" "postgres" {
  image         = docker_image.postgres_image.image_id
  name          = "postgres_db"
  restart       = "always"
  
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  ports {
    internal = 5432
    external = 5432
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }

  volumes {
    host_path      = abspath("${path.module}/sql/script.sql")
    container_path = "/docker-entrypoint-initdb.d/script.sql"
  }
}

# Configuração do backend
resource "docker_image" "backend_image" {
    name = "backend_image:latest"
    build {
        context    = "${path.module}/backend"
    }
}

resource "docker_container" "backend_app" {
  image         = docker_image.backend_image.image_id
  name          = "backend_app"
  restart       = "always"
  
  networks_advanced {
    name = docker_network.app_network.name
  }

  env = [
    "port=${var.backend_port}",
    "user=${var.db_user}",
    "pass=${var.db_password}",
    "db_port=${var.db_port}",
    "host=${var.db_host}",
    "db_name=${var.db_name}"
  ]

  depends_on = [docker_container.postgres]
}

# Configuração do frontend
resource "docker_image" "frontend_image" {
    name = "frontend_image:latest"
    build {
        context    = "${path.module}/frontend"
    }
}

resource "docker_container" "frontend" {
  image         = docker_image.frontend_image.image_id
  name          = "frontend_app"
  restart       = "always"
  
  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  depends_on = [docker_container.backend_app]
}