### Key for EC2:Remote_Employee

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

### Key for EC2:Company_SOC

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