resource "aws_instance" "instance_vpc1" {
  ami                         = local.ami
  instance_type               = "t4g.nano"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.sg["vpc1"].id]
  subnet_id                   = aws_subnet.public_a["vpc1"].id

  tags = {
    Name = "${local.name}-vpc1-instance"
  }
}

resource "aws_instance" "instance_vpc2" {
  ami                         = local.ami
  instance_type               = "t4g.nano"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.sg["vpc2"].id]
  subnet_id                   = aws_subnet.public_a["vpc2"].id

  tags = {
    Name = "${local.name}-vpc2-instance"
  }
}

resource "aws_security_group" "sg" {
  for_each = local.vpc
  vpc_id = aws_vpc.vpc[each.key].id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    description = "allow-all"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    description = "allow-all"
  }

  tags = {
    Name = "${local.name}-${each.key}-sg"
  }
}

resource "aws_key_pair" "key" {
  key_name   = "${local.name}-kp"
  public_key = file("id_rsa.pub")
}
