resource "aws_instance" "company_employee" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.company_subnet_id
  security_groups = [
    var.company_sg_id,
    var.company_dev_sg_id
  ]
  user_data = var.user_data
  key_name  = var.remote_key_name

  associate_public_ip_address = var.public_ip
  tags = {
    Name = var.ec2_name
  }
  
  depends_on = [
    var.bucket_id
  ]
}