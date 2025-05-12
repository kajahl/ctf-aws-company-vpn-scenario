#!/bin/bash

NEW_HOSTNAME="compay-archive"
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
sudo apt-get install -y nmap net-tools unzip

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
aws s3 cp s3://s3-ctf-files-bucket/company-archive/files.zip ~/files.zip

# download key for private ec2 company soc
aws s3 cp s3://s3-ctf-files-bucket/keys/soc-key.pem ~/key-to-company-soc.pem

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
local_root=/home/ftp/files
CONF
systemctl restart vsftpd

# extract files
unzip ~/files.zip -d ~/files
mv ~/files/* /home/ftp/files
chown -R ftp:ftp /home/ftp/files
chmod -R 755 /home/ftp/files

# usunięcie logów z tworzenia flag (i całego init.sh)
# sudo rm -rf /var/log/cloud-init*