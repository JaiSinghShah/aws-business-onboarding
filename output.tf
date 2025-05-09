output "vpc_ids" {
  value = { for k, v in aws_vpc.business_vpc : k => v.id }
}

output "subnet_ids" {
  value = { for k, v in aws_subnet.public_subnet : k => v.id }
}

output "security_group_ids" {
  value = { for k, v in aws_security_group.business_sg : k => v.id }
}
