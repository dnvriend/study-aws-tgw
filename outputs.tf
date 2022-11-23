output "instance_public_ip_vpc1" {
  value = aws_instance.instance_vpc1.public_ip
}

output "instance_public_ip_vpc2" {
  value = aws_instance.instance_vpc2.public_ip
}

