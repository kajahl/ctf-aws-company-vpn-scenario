resource "aws_security_group" "company_dev_sg" {
  name        = "company_dev_sg"
  description = "Publiczny dostep do infrastruktury prywatnej dla testow"
  vpc_id      = aws_vpc.company_vpc.id

  ingress {
    # Typowy port dla FTP (kontrola)
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Port dla danych FTP (aktywny FTP)
    from_port   = 20
    to_port     = 20
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Zakres portów pasywnego FTP
    from_port   = 10000
    to_port     = 10100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # ICMP - pozwala na ping (Echo Request/Reply)
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

output "company_dev_sg_id" {
  value       = aws_security_group.company_dev_sg.id
  description = "ID grupy zabezpieczen dla infrastruktury prywatnej (dev)"
}