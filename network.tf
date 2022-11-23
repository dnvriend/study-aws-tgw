resource "aws_vpc" "vpc" {
  for_each             = local.vpc
  cidr_block           = each.value.cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name}-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  for_each = local.vpc
  vpc_id   = aws_vpc.vpc[each.key].id

  tags = {
    Name = "${local.name}-${each.key}-igw"
  }
}

resource "aws_route_table" "public_rt_vpc1" {
  vpc_id = aws_vpc.vpc["vpc1"].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw["vpc1"].id
  }

  route {
    cidr_block         = local.vpc.vpc2.cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

#  route {
#    cidr_block         = local.vpc.vpc3.cidr
#    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#  }

  tags = {
    Name = "${local.name}-vpc1-public-rt"
  }
}

resource "aws_route_table" "public_rt_vpc2" {
  vpc_id = aws_vpc.vpc["vpc2"].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw["vpc2"].id
  }

  route {
    cidr_block         = local.vpc.vpc1.cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

#  route {
#    cidr_block         = local.vpc.vpc3.cidr
#    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#  }

  tags = {
    Name = "${local.name}-vpc2-public-rt"
  }
}

resource "aws_subnet" "public_a" {
  for_each          = local.vpc
  vpc_id            = aws_vpc.vpc[each.key].id
  cidr_block        = each.value.public_a
  availability_zone = "${local.region}a"

  tags = {
    Name = "${local.name}-${each.key}-public-a"
  }
}

resource "aws_route_table_association" "public_a_rt_vpc1" {
  subnet_id      = aws_subnet.public_a["vpc1"].id
  route_table_id = aws_route_table.public_rt_vpc1.id
}

resource "aws_route_table_association" "public_a_rt_vpc2" {
  subnet_id      = aws_subnet.public_a["vpc2"].id
  route_table_id = aws_route_table.public_rt_vpc2.id
}

resource "aws_subnet" "private_a" {
  for_each          = local.vpc
  vpc_id            = aws_vpc.vpc[each.key].id
  cidr_block        = each.value.private_a
  availability_zone = "${local.region}a"

  tags = {
    Name = "${local.name}-${each.key}-private-a"
  }
}
