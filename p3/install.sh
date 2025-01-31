#!/usr/bin/env bash

if [ $(id -u) -ne 0 ]; then
    echo "Run as root"
    exit 1
fi



echo "Setup docker for installation..."

apt-get update
apt-get install -y ca-certificates curl vim
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

echo "Finished to setup docker for installation !"
echo "Installing docker..."

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker installation finished !"
echo "Add docker group to user qbornet..."


if [ $(group qbornet  | grep -q "docker") -ne 0 ] && [[ cat /etc/groups | grep -q "docker" ]]; then
    /usr/sbin/usermod -aG docker qbornet
else
    /usr/sbin/groupadd docker
    /usr/sbin/usermod -aG docker qbornet
fi

echo "group docker addedd to user qbornet !"
echo "Installing kubectl..."

apt-get install -y apt-transport-https gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
chmod 644 /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubectl

echo "Installing k3d..."

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "Finished installation script !"
