output "public_web_urls" {
  # value       = ["http://${aws_instance.linuxvm.*.public_dns}"]
  value = [
    for pub_dns in aws_instance.linuxvm.*.public_dns: "http://${pub_dns}"
  ]
  description = "Public DNS Names of the EC2 Instances built."
}

output "private_keypair" {
  value       = "${local.private_key_filename}.pem"
  description = "Keypair name."
}

# output "ec2_instances" {
#   value = aws_instance.linuxvm
#   description = "EC2 Instances created."
# }