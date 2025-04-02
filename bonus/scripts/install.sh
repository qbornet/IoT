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

gitlab-rails runner "$(cat /home/thrio/IoT/bonus/confs/delete.rb)"
val=$(gitlab-rails runner "$(cat /home/thrio/IoT/bonus/confs/user.rb)" | grep -E "^Project URL: "  | sed -e 's/Project URL: //g' | tr -d ' ')
git clone https://github.com/qbornet/iot-thrio
cd iot-thrio
git remote set-url origin $val
git push -u origin main 

sh /home/thrio/IoT/bonus/scripts/install-argocd.sh
