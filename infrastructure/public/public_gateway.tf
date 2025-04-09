resource "aws_internet_gateway" "external_internet_gateway" {
  vpc_id = aws_vpc.external_vpc.id
  tags = {
    Name = "External Internet Gateway"
  }
}

resource "aws_route_table" "external_route_table" {
  vpc_id = aws_vpc.external_vpc.id
  tags = {
    Name = "External Route Table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.external_internet_gateway.id
  }
}

resource "aws_route_table_association" "external_subnet_association" {
  subnet_id      = aws_subnet.external_subnet.id
  route_table_id = aws_route_table.external_route_table.id
}