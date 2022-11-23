resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "${local.name}-tgw"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  multicast_support               = "disable"
  auto_accept_shared_attachments  = "enable"
  transit_gateway_cidr_blocks = []

  tags = {
    Name = "${local.name}-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_tgw_attachment" {
  for_each           = local.vpc
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc[each.key].id
  subnet_ids         = [
    aws_subnet.public_a[each.key].id,
#    aws_subnet.private_a[each.key].id
  ]

  tags = {
    Name = "${local.name}-tgw-${each.key}-attachment"
  }
}
