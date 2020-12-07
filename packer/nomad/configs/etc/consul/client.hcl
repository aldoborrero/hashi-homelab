server = false
advertise_addr = ""
advertise_addr_wan = ""
bind_addr = "{{GetInterfaceIP \"eth0\"}}"
client_addr = "0.0.0.0"
data_dir = "/var/consul"
datacenter = "home"
enable_syslog = true
log_level = "WARN"
retry_join = ["192.168.1.17", "192.168.1.18", "192.168.1.19"]
ui = true
