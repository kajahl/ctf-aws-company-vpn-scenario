resource "aws_vpc" "external_vpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "external_subnet" {
  vpc_id                  = aws_vpc.external_vpc.id
  availability_zone       = "us-east-1f"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
}

output "external_vpc_id" {
  value = aws_vpc.external_vpc.id
}

output "external_subnet_id" {
  value = aws_subnet.external_subnet.id
}