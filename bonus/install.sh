#!/usr/bin/env bash


# check if user is root
if [ $(id -u) -ne 0 ]; then
    echo "Run as root"
    exit 1
fi

apt-get update
apt-get install curl openssh-server ca-certificates perl -y

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | bash

apt-get update
EXTERNAL_URL='http://localhost:9999' apt-get install gitlab-ee

password=$(cat /etc/gitlab/initial_root_password | grep -E '^Password' | cut -f2 -d':' | tr -d ' ')
echo "root:$password"
sleep 60

gitlab-rails runner "$(pwd)/user.rb"

# k3d cluster rm part-three
# k3d cluster create --config ./cluster.yaml --wait
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
