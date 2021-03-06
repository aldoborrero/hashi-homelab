#!/usr/bin/env bash

set -o errexit

# Delete unncessary files for Consul
sudo rm /etc/consul/client.hcl

# Rename nomad file
sudo mv /etc/nomad/server.hcl /etc/nomad/nomad.hcl
sudo rm /etc/nomad/client.hcl

# Reload systemctl services
sudo systemctl daemon-reload

# Enable systemctl services
sudo systemctl enable coredns
sudo systemctl enable consul
sudo systemctl enable nomad
sudo systemctl enable vault
sudo systemctl enable node_exporter
