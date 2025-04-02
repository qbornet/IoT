#!/usr/bin/env sh

sudo apk update && sudo apk add net-tools
echo "Installing k3s"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip 192.168.56.110 --write-kubeconfig-mode 0644" K3S_TOKEN=12345 sh -s -
kubectl config set-cluster default --server=https://192.168.56.110:6443
