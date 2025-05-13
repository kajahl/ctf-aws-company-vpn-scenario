#!/bin/bash

NEW_HOSTNAME="company-archive"
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
aws s3 cp s3://s3-ctf-files-bucket/company-archive/files.zip ~/files.zip

# download key for private ec2 company soc
aws s3 cp s3://s3-ctf-files-bucket/keys/soc-key.pem ~/key-to-company-soc.pem

# vsftpd
apt-get install -y vsftpd
MY_PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
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
pasv_address=${MY_PRIVATE_IP}
CONF
systemctl restart vsftpd

# extract files
unzip ~/files.zip -d /srv/ftp/files
mv ~/key-to-company-soc.pem /srv/ftp/files/crypto_keys/ctf-FLAGA_CTF_16.pem
chown -R root:root /srv/ftp/
chmod -R 755 /srv/ftp/
chmod 400 /srv/ftp/files/crypto_keys/ctf-FLAGA_CTF_16.pem

# Install Apache
apt-get install -y apache2

# Move index.html to Apache's default directory
mv /srv/ftp/files/apache2/* /var/www/html/
rm /srv/ftp/files/apache2

# Set proper permissions for the web directory
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

# Restart Apache to apply changes
systemctl restart apache2

# Enable Apache to start on boot
systemctl enable apache2

# czyszczenie logów przed uczestnikiem
# usunięcie logów z tworzenia flag (i całego init.sh)
sudo rm -rf /var/log/cloud-init*
sudo rm ~/files.zip
sudo rm -r ~/files