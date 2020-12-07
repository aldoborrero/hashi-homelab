#!/usr/bin/env bash

set -o errexit

DEBIAN_FRONTEND=noninteractive

CONSUL_VERSION='1.9.0'
NOMAD_VERSION='0.12.9'
VAULT_VERSION='1.6.0'
COREDNS_VERSION='1.8.0'

# Add docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install -y docker-ce

# --- Add Consul
sudo wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -O /tmp/consul.zip
sudo unzip /tmp/consul.zip -d /tmp
sudo chmod +x /tmp/consul
sudo mv /tmp/consul /usr/local/bin
sudo mkdir -p /var/consul

# --- Add Nomad
sudo wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -O /tmp/nomad.zip
sudo unzip /tmp/nomad.zip -d /tmp
sudo chmod +x /tmp/nomad
sudo mv /tmp/nomad /usr/local/bin
sudo mkdir -p /var/nomad

# --- Add Vault
sudo wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -O /tmp/vault.zip
sudo unzip /tmp/vault.zip -d /tmp
sudo chmod +x /tmp/vault
sudo mv /tmp/vault /usr/local/bin
sudo mkdir -p /var/vault

# --- Add CoreDNS
sudo wget https://github.com/coredns/coredns/releases/download/v${COREDNS_VERSION}/coredns_${COREDNS_VERSION}_linux_amd64.tgz -O /tmp/coredns.tgz
sudo tar -xvvf /tmp/coredns.tgz --directory /tmp
sudo chmod +x /tmp/coredns
sudo mv /tmp/coredns /usr/local/bin
sudo apt install -y resolvconf
sudo mkdir -p /opt/coredns /etc/resolvconf/resolv.conf.d /var/lib/coredns /etc/coredns
echo 'nameserver 127.0.0.1' | sudo tee -a /etc/resolvconf/resolv.conf.d/head > /dev/null
sudo useradd -d /var/lib/coredns -m coredns
sudo chown coredns:coredns /opt/coredns

# --- Finish
exit 0
