# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "=3.42.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.aws_region
# }



resource "aws_vpc" "vpc01" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.dept}-vpc"
  }
}

resource "aws_subnet" "subnets" {
  for_each          = { for i, cidr_block in var.subnet_cidrs : cidr_block => i }
  cidr_block        = each.key
  vpc_id            = aws_vpc.vpc01.id
  availability_zone = element(var.availability_zones, each.value)

  tags = {
    Name = "${var.dept}-subnet${each.value}"
  }
}

resource "aws_security_group" "lxwebservers" {
  name   = "${var.dept}_lxwebservers"
  vpc_id = aws_vpc.vpc01.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sg_whitelist
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sg_whitelist
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-${var.dept}-lxwebservers"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc01.id

  tags = {
    Name = "${var.dept}-igw"
  }
}

resource "aws_route_table" "rt01" {
  vpc_id = aws_vpc.vpc01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.dept}-rt"
  }
}

data "aws_subnet_ids" "allsubnets" {
  vpc_id = aws_vpc.vpc01.id
  depends_on = [
    aws_subnet.subnets
  ]

}

resource "aws_route_table_association" "subnetroutes" {
  # for_each = data.aws_subnet_ids.allsubnets.ids
  count = length(var.subnet_cidrs)

  subnet_id      = tolist(data.aws_subnet_ids.allsubnets.ids)[count.index]
  route_table_id = aws_route_table.rt01.id
}

data "aws_ami" "centos7" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "^CentOS.*"

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "privatekey" {
  algorithm = "RSA"
}

resource "local_file" "aws_cloud_pem" {
  filename = "${var.dept}-ssh-key.pem"
  content  = tls_private_key.privatekey.private_key_pem
}

locals {
  private_key_filename = "${var.dept}-ssh-key.pem"
}

resource "aws_key_pair" "keypair" {
  key_name   = local.private_key_filename
  public_key = tls_private_key.privatekey.public_key_openssh
}

resource "aws_instance" "linuxvm" {
  # for_each = toset(data.aws_subnet_ids.allsubnets.ids)
  count = length(var.subnet_cidrs)

  # for_each = { for i, subnetids in data.aws_subnet_ids.allsubnets.ids : subnetids => i }

  ami                         = data.aws_ami.centos7.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = tolist(data.aws_subnet_ids.allsubnets.ids)[count.index]
  vpc_security_group_ids      = [aws_security_group.lxwebservers.id]
  key_name                    = aws_key_pair.keypair.key_name

  tags = {
    Name = "${var.dept}-instance-${count.index}"
  }

  user_data = <<EOF
  #!/bin/bash
  yum install -y httpd
  systemctl start httpd.service
  echo -e "<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Webserver deployed using Terraform</title>
    <style>
        .h {
            font-family: 'Open Sans';
            font-size: 40px;
        }
    </style>

</head>

<body>
    <p class="h">Website deployed using Terraform</p>
    <p class="h">Well ! its working</p>
</body>

</html>"  >> /var/www/html/index.html
chmod a+r /var/www/html/index.html
EOF

}


