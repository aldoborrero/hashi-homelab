#!/usr/bin/env bash

set -o errexit

# Delete unncessary files for Consul
sudo rm /etc/consul/server.hcl

# Reload systemctl services
sudo systemctl daemon-reload

# Enable systemctl services
sudo systemctl enable consul
sudo systemctl enable nomad
sudo systemctl enable vault
sudo systemctl enable node_exporter
