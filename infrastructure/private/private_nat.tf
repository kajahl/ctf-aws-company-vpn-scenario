resource "aws_subnet" "company_public_subnet" {
  vpc_id                  = aws_vpc.company_vpc.id
  availability_zone       = aws_subnet.company_subnet.availability_zone
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = { Name = "Company Public Subnet" }
}

resource "aws_route_table_association" "company_public_assoc" {
  route_table_id = aws_route_table.company_route_table.id
  subnet_id      = aws_subnet.company_public_subnet.id
}

resource "aws_eip" "company_nat_eip" {
  tags = {
    Name = "Company NAT EIP"
  }
}

resource "aws_nat_gateway" "company_nat" {
  allocation_id = aws_eip.company_nat_eip.id
  subnet_id     = aws_subnet.company_public_subnet.id

  tags = { Name = "Company NAT Gateway" }
}

resource "aws_route_table" "company_private_route_table" {
  vpc_id = aws_vpc.company_vpc.id
  tags   = { Name = "Company Private Route Table" }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.company_nat.id
  }
}

resource "aws_route_table_association" "company_private_assoc" {
  route_table_id = aws_route_table.company_private_route_table.id
  subnet_id      = aws_subnet.company_subnet.id
}

## Następny krok - do każdego init.sh dodać czekanie na internet i instalacje odpowiednich paczek