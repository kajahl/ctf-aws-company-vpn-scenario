resource "aws_vpc" "shared_vpc" {
  cidr_block = "172.20.0.0/16"
}

resource "aws_subnet" "shared_subnet" {
  vpc_id                  = aws_vpc.shared_vpc.id
  cidr_block              = "172.20.1.0/24"
  availability_zone       = "us-east-1f"
  map_public_ip_on_launch = false
}

output "shared_vpc_id" {
  value = aws_vpc.shared_vpc.id
}

output "shared_subnet_id" {
  value = aws_subnet.shared_subnet.id
}