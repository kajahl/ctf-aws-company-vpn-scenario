resource "aws_security_group" "company_sg" {
  vpc_id      = aws_vpc.company_vpc.id
  name        = "company_sg"
  description = "Dostep do uslug instancji EC2 w VPC (EC2:Company_Employee, EC2:Company_SOC, EC2:Company_Archive)"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "company_sg_id" {
  value = aws_security_group.company_sg.id
}