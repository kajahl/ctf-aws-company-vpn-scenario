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
aws s3 cp s3://s3-ctf-files-bucket/company-archive/soc-key.pem ~/soc-key.pem
aws s3 cp s3://s3-ctf-files-bucket/company-archive/files.zip ~/files.zip

# vsftpd
apt-get install -y vsftpd
MY_PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
cat <<CONF > /etc/vsftpd.conf
listen=YES
anonymous_enable=YES
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
pasv_enable=YES
pasv_min_port=10000
pasv_max_port=10100
pasv_address=${MY_PUBLIC_IP}
CONF
systemctl restart vsftpd

sudo apt install nmap
sudo apt install net-tools