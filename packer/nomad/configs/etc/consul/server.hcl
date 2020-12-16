server = true
ui = true
client_addr = "0.0.0.0"
advertise_addr = ""
advertise_addr_wan = ""
bind_addr = "{{GetInterfaceIP \"ens18\"}}"
bootstrap_expect = 3
data_dir = "/var/consul"
datacenter = "home"
enable_syslog = true
log_level = "WARN"
retry_join = ["nomad-server-1.home", "nomad-server-2.home", "nomad-server-3.home"]
