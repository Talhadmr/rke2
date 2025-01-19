#!/bin/bash
# scripts/rke2_manager.sh

set -xe

# Update system packages
apt-get update -y
apt-get upgrade -y
apt-get install -y curl wget

# Install RKE2 (server)
curl -sfL https://get.rke2.io | sh -

# Create config directory
mkdir -p /etc/rancher/rke2

cat <<EOF >/etc/rancher/rke2/config.yaml
token: "${RKE2_CLUSTER_TOKEN}"
write-kubeconfig-mode: "0644"
tls-san:
  - "$(hostname -I | awk '{print $1}')"
# Additional configurations can be added here
EOF

systemctl enable rke2-server
systemctl start rke2-server

# Create a symlink for kubectl
ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl || true

echo "Manager installation is complete."