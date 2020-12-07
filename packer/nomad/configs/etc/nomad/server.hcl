data_dir = "/var/nomad/"
datacenter = "dc1"
region = "home"
log_level = "warn"
bind_addr = "0.0.0.0"

server {
  enabled = true
  authoritative_region = "home"
  bootstrap_expect = 3
  heartbeat_grace = "300s"
  min_heartbeat_ttl = "20s"
}

acl {
  enabled = false
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
  client_service_name = "nomad-server"
  auto_advertise = true
  server_auto_join = true
  client_auto_join = true
}

vault {
  enabled = true
  address = "http://vault.service.consul:8200"
  token   = ""
}
