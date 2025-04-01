resource "aws_vpc" "company_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "company_subnet" {
  vpc_id                  = aws_vpc.company_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

resource "aws_security_group" "company_sg" {
  vpc_id = aws_vpc.company_vpc.id

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

resource "aws_instance" "company_pc1" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.company_subnet.id
  security_groups = [aws_security_group.company_sg.id]
  key_name        = aws_key_pair.generated_key.key_name
  tags = {
    Name = "Company PC #1"
  }
}

resource "aws_instance" "company_pc2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.company_subnet.id
  security_groups = [aws_security_group.company_sg.id]
  key_name        = aws_key_pair.generated_key.key_name
  tags = {
    Name = "Company PC #2"
  }
}

resource "aws_instance" "company_pc3" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.company_subnet.id
  security_groups = [aws_security_group.company_sg.id]
  key_name        = aws_key_pair.generated_key.key_name
  tags = {
    Name = "Company PC #3"
  }
}