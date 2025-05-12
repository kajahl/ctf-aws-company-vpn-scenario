#!/bin/bash

NEW_HOSTNAME="company-employee"
hostnamectl set-hostname "$NEW_HOSTNAME"

if ! grep -q "$NEW_HOSTNAME" /etc/hosts; then
  sed -i "1 s/^/127.0.1.1\t$NEW_HOSTNAME\n/" /etc/hosts
fi

until ping -c1 8.8.8.8 &>/dev/null; do
  echo "Brak sieci, próbuję ponownie za 5s…"
  sleep 5
done

apt-get update && apt-get upgrade -y

# install tools
sudo apt-get install -y nmap net-tools unzip ftp

# install aws cli
apt-get install -y awscli
mkdir -p ~/.aws

# credentials file
cat <<EOL > ~/.aws/credentials
___AWS_CREDENTIALS_FILE___
EOL

# config file 
cat <<EOL > ~/.aws/config
[default]
region = us-east-1
output = json
EOL

# s3-bucket file structure
aws s3 cp s3://s3-ctf-files-bucket/company-employee/files.zip ~/files.zip

# extract files
unzip ~/files.zip -d ~/files
mv ~/files/* /home/ubuntu/
chown -R ubuntu:ubuntu /home/ubuntu/files

# usunięcie logów z tworzenia flag (i całego init.sh)
sudo rm -rf /var/log/cloud-init*