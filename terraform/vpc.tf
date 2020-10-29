// grab the availability zones for the region we set in var.tf
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = local.tag_name
  }
}

resource "aws_subnet" "public" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${local.tag_name}-public"
  }
}

// RDS cluster in serverless mode requires at least 3 AZs
resource "aws_subnet" "private_1" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${local.tag_name}-private-1"
  }
}

resource "aws_subnet" "private_2" {
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${local.tag_name}-private-2"
  }
}

resource "aws_subnet" "private_3" {
  cidr_block = "10.0.4.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name = "${local.tag_name}-private-3"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = local.tag_name
  }
}

// NAT gateway requires an elastic ip
resource "aws_eip" "public" {
  tags = {
    Name = local.tag_name
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.public.id
  // connect to public subnet
  subnet_id = aws_subnet.public.id
  tags = {
    Name = local.tag_name
  }
}

// Output the subnet ids which will be used in the serverless.yml later
output "subnet_private_1" {
  value = aws_subnet.private_1.id
}

output "subnet_private_2" {
  value = aws_subnet.private_2.id
}

output "subnet_private_3" {
  value = aws_subnet.private_3.id
}
