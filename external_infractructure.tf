resource "aws_vpc" "external_vpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "external_subnet" {
  vpc_id                  = aws_vpc.external_vpc.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "external_igw" {
  vpc_id = aws_vpc.external_vpc.id
}

resource "aws_route_table" "external_route_table" {
  vpc_id = aws_vpc.external_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.external_igw.id
  }
}

resource "aws_route_table_association" "external_subnet_association" {
  subnet_id      = aws_subnet.external_subnet.id
  route_table_id = aws_route_table.external_route_table.id
}

resource "aws_security_group" "external_pc_sg" {
  vpc_id = aws_vpc.external_vpc.id

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

resource "aws_instance" "external_pc" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.external_subnet.id
  security_groups             = [aws_security_group.external_pc_sg.id]
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  tags = {
    Name = "External PC"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update && apt install -y openvpn nmap
              EOF
}