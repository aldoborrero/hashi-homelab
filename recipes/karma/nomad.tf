job "karma" {
  region      = "[[ .region ]]"
  datacenters = ["[[ .datacenter ]]"]
  type        = "service"

  meta {
    version = "1"
  }

  group "karma" {
    count = 1

    task "karma" {
      driver = "docker"

      config {
        image        = "lmierzwa/karma:v0.70"
        network_mode = "host"
        force_pull   = false
      }

      env {
        HOST               = "${NOMAD_IP_http}"
        PORT               = "${NOMAD_PORT_http}"
        ALERTMANAGER_URI   = "https://${NOMAD_TASK_NAME}[[ .tld ]]"
        ALERTMANAGER_PROXY = "true"
      }

      service {
        port = "http"
        name = "alerts"
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
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 20
        memory = 24
        network {
          port "http" {}
        }
      }
    }
  }
}
