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

  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.db_user} -d ${var.db_name}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
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
    "db_port=5432",
    "host=${docker_container.postgres.name}",
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

# Configuração do Monitoramento
## Configuração do Nginx Exporter
resource "docker_image" "nginx_exporter_image" {
  name = "nginx/nginx-prometheus-exporter:latest"
}

resource "docker_container" "nginx_exporter" {
  image = docker_image.nginx_exporter_image.image_id
  name  = "nginx_exporter"
  restart = "always"

  networks_advanced {
    name = docker_network.app_network.name
  }

  env = [
    "NGINX_SCRAPE_URI=http://frontend:80/stub_status"
  ]

  depends_on = [docker_container.frontend]
}
## Volumes para os dados do Prometheus e Grafana
resource "docker_volume" "prometheus_data" {
  name = "prometheus_data"
}

resource "docker_volume" "grafana_data" {
  name = "grafana_data"
}

## Imagem do Prometheus
resource "docker_image" "prometheus_image" {
  name = "prom/prometheus:latest"
}

## Container do Prometheus
resource "docker_container" "prometheus_app" {
  image = docker_image.prometheus_image.image_id
  name  = "prometheus_app"
  restart = "always"

  ports {
    internal = 9090
    external = 9090
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    host_path = abspath("${path.module}/prometheus")
    container_path = "/etc/prometheus"
  }

  volumes {
    volume_name = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  depends_on = [docker_container.nginx_exporter]
}

## Imagem do Grafana
resource "docker_image" "grafana_image" {
  name = "grafana/grafana:10.1.5"
}

## Container do Grafana
resource "docker_container" "grafana_app" {
  image = docker_image.grafana_image.image_id
  name  = "grafana_app"
  restart = "always"

  ports {
    internal = 3000
    external = 3001
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  depends_on = [docker_container.prometheus_app]
}