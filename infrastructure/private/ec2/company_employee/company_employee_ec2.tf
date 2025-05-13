resource "aws_network_interface" "shared_eni" {
  subnet_id       = var.shared_subnet_id
  security_groups = [var.shared_sg_id]
  tags = {
    Name = "Shared ENI for EC2.B"
  }
}

resource "aws_network_interface" "primary_eni" {
  subnet_id = var.company_subnet_id
  security_groups = [
    var.company_sg_id
  ]
  tags = {
    Name = "Primary ENI for EC2.B"
  }
}

resource "aws_instance" "company_employee" {
  ami           = var.ami_id
  instance_type = var.instance_type
#   subnet_id     = var.company_subnet_id
#   security_groups = [
    # var.company_sg_id
#   ]
  user_data = var.user_data
  key_name  = var.remote_key_name

  tags = {
    Name = var.ec2_name
  }

  network_interface {
    network_interface_id = aws_network_interface.primary_eni.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.shared_eni.id
    device_index         = 1
  }

  depends_on = [
    var.bucket_id,
    aws_network_interface.shared_eni,
    aws_network_interface.primary_eni
  ]
}