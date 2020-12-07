job "alertmanager" {
  region      = "[[ .region ]]"
  datacenters = ["[[ .datacenter ]]"]
  type        = "service"

  meta {
    version = "1"
  }

  constraint {
    attribute = "${attr.unique.hostname}"
    value     = "[[ .app.alertmanager.node ]]"
  }

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "alertmanager" {
    count = 1

    ephemeral_disk {
      sticky = true
    }

    task "alertmanager" {
      driver = "docker"

      config {
        image        = "prom/alertmanager:v0.21.0"
        network_mode = "host"
        force_pull   = false
        args = [
          "--web.external-url",
          "https://${NOMAD_TASK_NAME}[[ .tld ]]",
          "--config.file",
          "/local/config.yml",
          "--storage.path",
          "/local/alertmanager",
          "--web.listen-address",
          "0.0.0.0:9093"
        ]
      }

      service {
        name = "alertmanager"
        port = "http"
        tags = [
          "traefik.enable=true",
          "traefik.http.middlewares.httpsRedirect.redirectscheme.scheme=https",
          "traefik.http.routers.${NOMAD_TASK_NAME}_http.entrypoints=http",
          "traefik.http.routers.${NOMAD_TASK_NAME}_http.middlewares=httpsRedirect",
          "traefik.http.routers.${NOMAD_TASK_NAME}_http.rule=Host(`${NOMAD_TASK_NAME}[[ .tld ]]`)",
          "traefik.http.routers.${NOMAD_TASK_NAME}_https.entrypoints=https",
          "traefik.http.routers.${NOMAD_TASK_NAME}_https.rule=Host(`${NOMAD_TASK_NAME}[[ .tld ]]`)",
          "traefik.http.routers.${NOMAD_TASK_NAME}_https.tls.domains[0].sans=${NOMAD_TASK_NAME}[[ .tld ]]",
        ]
        check {
          type     = "tcp"
          port     = "http"
          interval = "10s"
          timeout  = "2s"
        }
      }

      template {
        data = <<EOH
global:

route:

receivers:

EOH

        destination     = "local/config.yml"
        env             = false
        left_delimiter  = "{{{{"
        right_delimiter = "}}}}"
      }

      resources {
        cpu    = 20
        memory = 24

        network {
          port "http" { static = 9093 }
        }
      }
    }

  }
}
