output "created_subnets" {
  depends_on = [
    data.aws_subnet_ids.allsubnets,
    aws_subnet.subnets
  ]
  description = "Subnet IDs"
  value       = tolist(data.aws_subnet_ids.allsubnets.ids)[2 - 1]
}

output "linuxvms" {
  value = aws_instance.linuxvm
}