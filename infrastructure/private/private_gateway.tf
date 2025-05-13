resource "aws_internet_gateway" "company_internet_gateway" {
  vpc_id = aws_vpc.company_vpc.id
  tags = {
    Name = "Company Internet Gateway"
  }
}

resource "aws_route_table" "company_route_table" {
  vpc_id = aws_vpc.company_vpc.id
  tags = {
    Name = "Company Route Table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.company_internet_gateway.id
  }
}
