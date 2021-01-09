#!/usr/bin/env bash

set -o errexit

DEBIAN_FRONTEND=noninteractive

NODE_EXPORTER_VERSION='1.0.1'

# Add node_exporter
sudo wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz -O /tmp/nodeexporter.tgz
sudo tar -xvvf /tmp/nodeexporter.tgz --directory /tmp
sudo mv /tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64 /tmp/node_exporter
sudo chmod +x /tmp/node_exporter
sudo mv /tmp/node_exporter /usr/sbin/node_exporter
sudo mkdir -p /etc/sysconfig
sudo cp /tmp/configs/etc/sysconfig/* /etc/sysconfig/

# Add Wireguard
sudo apt update -y
sudo apt install -y wireguard qrencode

# Enable NAT forwarding
echo "net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" > /etc/sysctl.d/wg.conf
sudo sysctl --system
