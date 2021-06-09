resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_names = sort(data.aws_availability_zones.available.names)
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "InternetGateway"
  }
}

resource "aws_route_table" "my_vpc_ap_southeast_1a_public" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }

    tags = {
        Name = "Public Subnet Route Table."
    }
}

resource "aws_route_table_association" "my_vpc_ap_southeast_1a_public" {
    subnet_id = aws_subnet.ap-southeast-1a-public.id
    route_table_id = aws_route_table.my_vpc_ap_southeast_1a_public.id
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.ap-southeast-1a-public.id
  tags = {
    "Name" = "NatGateway"
  }
}

resource "aws_route_table" "my_vpc_ap_southeast_1a_private" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "instance" {
  subnet_id = aws_subnet.ap-southeast-1a-private.id
  route_table_id = aws_route_table.my_vpc_ap_southeast_1a_private.id
}