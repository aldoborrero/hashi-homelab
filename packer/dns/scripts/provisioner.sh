#!/usr/bin/env bash

set -o errexit

DEBIAN_FRONTEND=noninteractive

NODE_EXPORTER_VERSION='1.0.1'

# Update
sudo apt update

# Add node_exporter
sudo wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz -O /tmp/nodeexporter.tgz
sudo tar -xvvf /tmp/nodeexporter.tgz --directory /tmp
sudo mv /tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64 /tmp/node_exporter
sudo chmod +x /tmp/node_exporter
sudo mv /tmp/node_exporter /usr/sbin/node_exporter
sudo mkdir -p /etc/sysconfig
sudo cp /tmp/configs/etc/sysconfig/* /etc/sysconfig/

# Remove resolved
sudo systemctl disable systemd-resolved
sudo systemctl mask systemd-resolved
sudo systemctl stop systemd-resolved

# Install unbound
sudo apt install unbound

# Copy systemd files
sudo cp /tmp/configs/etc/systemd/system/* /etc/systemd/system/

# Reload systemctl services
sudo systemctl daemon-reload

# Enable systemctl services
sudo systemctl enable node_exporter
sudo systemctl enable roothints
sudo systemctl enable unbound
