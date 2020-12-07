services = {
  checks = {
    interval = "30s"
    tcp = "localhost:8500"
    timeout = "1s"
  }
  name = "consul-agent"
  port = 8500
  tags = ["net-internal"]
}
