### Key for EC2:Remote_Employee - Pierwszy klucz do EC2

resource "tls_private_key" "remote_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_remote_key" {
  key_name   = "ctf-key"
  public_key = tls_private_key.remote_key.public_key_openssh
  tags = {
    key = "ctf-key"
  }
}

resource "local_file" "remote_private_key" {
  content  = tls_private_key.remote_key.private_key_pem
  filename = "${path.module}/ctf-key.pem"
}

output "remote_key_name" {
  value       = aws_key_pair.generated_remote_key.key_name
  description = "The name of the generated key pair for Remote Employee"
}

### Key for EC2:Company_Employee - Drugi klucz do EC2

resource "tls_private_key" "employee_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_employee_key" {
  key_name   = "employee-key"
  public_key = tls_private_key.employee_key.public_key_openssh
  tags = {
    key = "employee-key"
  }
}

resource "local_file" "employee_private_key" {
  content  = tls_private_key.employee_key.private_key_pem
  filename = "${path.module}/employee-key.pem"
}

output "employee_key_name" {
  value       = aws_key_pair.generated_employee_key.key_name
  description = "The name of the generated key pair for Company Employee"
}

output "employee_private_key" {
  value       = tls_private_key.employee_key.private_key_pem
  description = "The private key for Company Employee"
  sensitive   = true
}

### Key for EC2:Company_SOC - Klucz do SOC, Trzeci klucz do EC2

resource "tls_private_key" "soc_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_soc_key" {
  key_name   = "soc-key"
  public_key = tls_private_key.soc_key.public_key_openssh
  tags = {
    key = "soc-key"
  }
}

resource "local_file" "soc_private_key" {
  content  = tls_private_key.soc_key.private_key_pem
  filename = "${path.module}/soc-key.pem"
}

output "soc_key_name" {
  value       = aws_key_pair.generated_soc_key.key_name
  description = "The name of the generated key pair for Company SOC"
}

output "soc_private_key" {
  value       = tls_private_key.soc_key.private_key_pem
  description = "The private key for Company SOC"
  sensitive   = true
}

### General "NoAccess" Key - Klucz do NoAccess, Klucz do Archiwum, nikt nie ma dostępu do tego klucza
# Dostęp tylko przez ftp

resource "tls_private_key" "noaccess_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_noaccess_key" {
  key_name   = "noaccess-key"
  public_key = tls_private_key.noaccess_key.public_key_openssh
  tags = {
    key = "noaccess-key"
  }
}

resource "local_file" "noaccess_private_key" {
  content  = tls_private_key.noaccess_key.private_key_pem
  filename = "${path.module}/noaccess-key.pem"
}

output "noaccess_key_name" {
  value       = aws_key_pair.generated_noaccess_key.key_name
  description = "The name of the generated key pair for Company NoAccess"
}

output "noaccess_private_key" {
  value       = tls_private_key.noaccess_key.private_key_pem
  description = "The private key for Company NoAccess"
  sensitive   = true
}