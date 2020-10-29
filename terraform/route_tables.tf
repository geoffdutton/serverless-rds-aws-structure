resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.tag_name}-public"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public_subnet.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public_subnet.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}


resource "aws_route_table" "private_lambda" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.tag_name}-private-lambda"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private_lambda.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_lambda.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_route_table_association" "private_2" {
  route_table_id = aws_route_table.private_lambda.id
  subnet_id      = aws_subnet.private_2.id
}

resource "aws_route_table_association" "private_3" {
  route_table_id = aws_route_table.private_lambda.id
  subnet_id      = aws_subnet.private_3.id
}
