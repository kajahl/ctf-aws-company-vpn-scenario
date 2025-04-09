resource "aws_security_group" "external_sg" {
  vpc_id      = aws_vpc.external_vpc.id
  name        = "external_sg"
  description = "Security group for external PC (EC2:Remote_Employee)"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "external_sg_id" {
  value = aws_security_group.external_sg.id
}
