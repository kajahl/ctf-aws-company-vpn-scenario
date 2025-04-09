#!/bin/bash
# Instalacja i konfiguracja FTP
apt-get update && apt-get upgrade -y
apt-get install -y vsftpd

# Publiczne IP w celu dostępu do FTP
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

# Tworzenie struktury katalogów i generowanie zaszyfrowanych danych
archive_root="/srv/ftp/archiwum"
declare -a dirs=("Finanse" "HR" "Projekty" "Legal")
for dir in "${dirs[@]}"; do
  mkdir -p "${archive_root}/${dir}"
done

generate_random_encrypted_file() {
  local file_path="$1"
  local file_size_kb="$2"
  dd if=/dev/urandom bs=1024 count="${file_size_kb}" 2>/dev/null | openssl enc -aes-256-cbc -salt -pass pass:CTFsecret -out "${file_path}"
}

for dir in "${dirs[@]}"; do
  # Losowa liczba plików, min 10, max 20
  num_files=$((RANDOM % 11 + 10))
  for i in $(seq 1 "${num_files}"); do
    # Losowy rozmiar pliku (od 5 KB do 50 KB)
    file_size=$((RANDOM % 46 + 5))
    # Generowanie losowej nazwy pliku
    file_name="${dir}_$(date +%s%N | cut -b1-13)_$((RANDOM % 1000)).bin"
    generate_random_encrypted_file "${archive_root}/${dir}/${file_name}" "${file_size}"
  done
done
