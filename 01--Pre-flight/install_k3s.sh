#!/bin/bash

# ==============================================================
# Install k3s
# Configure kubectl 
#
# 24/04/2022
# ==============================================================

# Install k3s - Rancher
curl -sfL https://get.k3s.io | sh - --disable servicelb --disable traefik

# Connect and test kubectl
chown -R pentaho /etc/rancher/k3s/k3s.yaml
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
chown $USER:$GROUP ~/.kube/config
systemctl enable k3s
kubectl get pods -A
echo -e "k3s Installation Completed .."

sleep 3s
echo -e "Reboot required .."
reboot