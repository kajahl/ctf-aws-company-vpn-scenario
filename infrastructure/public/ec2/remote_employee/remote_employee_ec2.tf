resource "aws_instance" "external_pc" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.external_subnet_id
  security_groups = [var.external_sg_id]
  user_data       = var.user_data
  key_name        = var.remote_key_name

  associate_public_ip_address = var.public_ip
  tags = {
    Name = var.ec2_name
  }

  depends_on = [
    var.bucket_id
  ]
}

output "external_pc_public_ip" {
  value = aws_instance.external_pc.public_ip
  description = "Public IP of the Remote Employee EC2 instance"
}