resource "aws_network_interface" "shared_eni" {
  subnet_id       = var.shared_subnet_id
  security_groups = [var.shared_sg_id]
  tags = {
    Name = "Shared ENI for EC2.A"
  }
}

resource "aws_network_interface" "primary_eni" {
  subnet_id       = var.external_subnet_id
  security_groups = [var.external_sg_id]
  tags = {
    Name = "Primary ENI for EC2.A"
  }
}

resource "aws_instance" "external_pc" {
  ami             = var.ami_id
  instance_type   = var.instance_type
#   subnet_id       = var.external_subnet_id
#   security_groups = [var.external_sg_id]
  user_data       = var.user_data
  key_name        = var.remote_key_name

  network_interface {
    network_interface_id = aws_network_interface.primary_eni.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.shared_eni.id
    device_index         = 1
  }

  tags = {
    Name = var.ec2_name
  }

  depends_on = [
    var.bucket_id,
    aws_network_interface.primary_eni,
    aws_network_interface.shared_eni,
    aws_s3_object.remote_employee_files,
    var.employee_key_s3_id
  ]
}

resource "aws_eip" "primary_eip" {
  depends_on = [ aws_instance.external_pc ]
}

resource "aws_eip_association" "primary_eip_assoc" {
  allocation_id        = aws_eip.primary_eip.id
  network_interface_id = aws_network_interface.primary_eni.id
}

output "external_pc_public_ip" {
  value       = aws_eip.primary_eip.public_ip
  description = "Public IP of the Remote Employee EC2 instance"
}