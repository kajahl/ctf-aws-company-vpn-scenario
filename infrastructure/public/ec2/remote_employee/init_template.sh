#!/bin/bash
apt-get update && apt-get upgrade -y

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
aws s3 cp s3://s3-ctf-files-bucket/remote-employee/files.zip ~/files.zip

# install tools
sudo apt install nmap
sudo apt install net-tools

# flagi

sudo ip link add name ctf-FLAGA_CTF_1 type dummy
sudo ip link set ctf-FLAGA_CTF_1 up