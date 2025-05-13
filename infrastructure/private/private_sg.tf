resource "aws_security_group" "company_sg" {
  vpc_id      = aws_vpc.company_vpc.id
  name        = "company_sg"
  description = "Dostep do uslug instancji EC2 w VPC (EC2:Company_Employee, EC2:Company_SOC, EC2:Company_Archive)"

  # Ingress rules (ruch przychodzący)

  # HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH (Secure Shell) - dostęp do instancji EC2 w VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # FTP (kontrola) - port 21
  ingress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # FTP (dane aktywne) - port 20
  ingress {
    from_port   = 20
    to_port     = 20
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # FTP (dane pasywne) - zakres portów 10000-10100
  ingress {
    from_port   = 10000
    to_port     = 10100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP (ping) - Echo Request/Reply
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules (ruch wychodzący)

  # Zezwolenie na cały ruch wychodzący
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