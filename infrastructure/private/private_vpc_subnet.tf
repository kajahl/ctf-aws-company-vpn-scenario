resource "aws_vpc" "company_vpc" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "company_subnet" {
  vpc_id                  = aws_vpc.company_vpc.id
  availability_zone       = "us-east-1f"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

output "company_vpc_id" {
  value = aws_vpc.company_vpc.id
}

output "company_subnet_id" {
  value = aws_subnet.company_subnet.id
}