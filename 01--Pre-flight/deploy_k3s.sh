#!/bin/bash

# ==============================================================
# Install k3s -disable traefik
# Configure kubectl 
#
# 24/04/2022
# ==============================================================

# Install k3s - Rancher
curl https://get.k3s.io | sudo INSTALL_K3S_COMMIT=$COMMIT INSTALL_K3S_TYPE=server sh -s - --cluster-init --disable traefik

# Connect and test kubectl
mkdir $HOME/.kube
chown -R $(id -u) /etc/rancher/k3s/*
cp -i /etc/rancher/k3s/k3s.yaml  $HOME/.kube/config
chown -R  $(id -u):$(id -g) $HOME/.kube/*
systemctl enable k3s
sleep 5s
echo -e "k3s Installation Completed .."
sleep 5s
echo -e "Reboot required .."
reboot