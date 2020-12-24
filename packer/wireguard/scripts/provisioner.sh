#!/usr/bin/env bash

set -o errexit

DEBIAN_FRONTEND=noninteractive

sudo apt update
sudo apt install wireguard
