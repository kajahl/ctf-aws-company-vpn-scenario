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
  description = "The name of the generated key pair for "
}