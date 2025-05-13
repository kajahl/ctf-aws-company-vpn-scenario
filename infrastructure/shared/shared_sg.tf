resource "aws_security_group" "shared_sg" {
  name        = "shared-sg"
  description = "Security group for shared subnet"
  vpc_id      = aws_vpc.shared_vpc.id

  // SSH access (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.20.1.0/24"]
  }

  // TCP access
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["172.20.1.0/24"]
  }

  // ICMP (ping)
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.20.1.0/24"]
  }

  // Outbound TCP
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Outbound ICMP
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "shared_sg_id" {
  value = aws_security_group.shared_sg.id
}