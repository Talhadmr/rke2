#!/bin/bash
# scripts/rke2_worker.sh

set -xe

# Update system packages
apt-get update -y
apt-get upgrade -y
apt-get install -y curl wget

# Install RKE2 (agent)
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -

# Create config directory
mkdir -p /etc/rancher/rke2

cat <<EOF >/etc/rancher/rke2/config.yaml
token: "${RKE2_CLUSTER_TOKEN}"
server: "https://${RKE2_SERVER_IP}:9345"
EOF

systemctl enable rke2-agent
systemctl start rke2-agent

# Create a symlink for kubectl
ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl || true

echo "Worker installation is complete."
