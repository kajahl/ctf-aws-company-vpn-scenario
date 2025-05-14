#!/bin/bash

NEW_HOSTNAME="company-soc"
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
sudo apt-get install -y nmap net-tools unzip tree
sudo apt-get install -y wget curl

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
aws s3 cp s3://s3-ctf-files-bucket-UNIQUE_ID/company-soc/files.zip ~/files.zip

# extract files
unzip ~/files.zip -d ~/files
mv ~/files /home/ubuntu/*
chown -R ubuntu:ubuntu /home/ubuntu/*

# czyszczenie logów przed uczestnikiem
# usunięcie logów z tworzenia flag (i całego init.sh)
sudo rm -rf /var/log/cloud-init*
sudo rm ~/files.zip
sudo rm -r ~/files