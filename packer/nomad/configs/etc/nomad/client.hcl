data_dir = "/var/nomad/"
datacenter = "dc1"
region = "home"
log_level = "warn"
bind_addr = "0.0.0.0"

acl {
  enabled = false
}

client {
  enabled = true
  network_interface = ""

  options = {
    docker.privileged.enabled = true
    docker.volumes.enabled = true
    docker.caps.whitelist = "ALL"
    driver.raw_exec.enable = "1"
  }

  meta {
    hardware = "nuc"
  }
}

telemetry {
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
  use_node_name = true
}

consul {
  address = "127.0.0.1:8500"
  client_service_name = "nomad-client"
  auto_advertise = true
  server_auto_join = true
  client_auto_join = true
}

vault {
  enabled = true
  address = "http://vault.service.consul:8200"
}
