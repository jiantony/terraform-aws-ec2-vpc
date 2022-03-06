# terraform-aws-ec2-vpc

Terraform module which creates one EC2 instance on given AWS availability zones and attach internet gateway and security group ingress rules to allow access to the Linux VM and Web service.

This was created just to demonstrate the Terraform module build process as part of Telstra Automathon. Not designed for production purpose.

- Create a VPC
- Create requested number of subnets, one in each AZ
- Create Internet Gateway
- Public route table and attach to newly created subnets
- TLS Keypair and save it locally
- Security Groups to permit tcp/22 and tcp/80 access to newly built VMs

## Usage

### Create the EC2 instances with default configuration

```hcl
module "ec2-vpc" {
  source = "app.terraform.io/Daffodil/ec2-vpc/aws"
  dept   = var.dept
}
```

## Examples:

- [Simple EC2 build] (github.com/jiantony/terraform-aws-ec2-vpc/tree/master/examples/simple) Simple EC2 build with default options

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.69 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.69 |

## Modules

No modules.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|aws_region|Specify the AWS Region|string|us-east-1|no|
|vpc_cidr|CIDR for the new VPC|string|10.10.0.0/16|no|
|subnet_cidrs|CIDRs for the subnets|list(string)|["10.10.1.0/24"| "10.10.2.0/24"| "10.10.3.0/24"]|no|
|availability_zones|Availability zones where the EC2 instances to be built|list(string)|["10.10.1.0/24"| "10.10.2.0/24"| "10.10.3.0/24"]|no|
|dept|Department name to be used for Name tag|string|TEST|no|
|sg_whitelist|Address ranges to whitelist for server access|list(string)|["0.0.0.0/0""]|no|
|instance_type|Type of EC2 instance to be built|string|t2.micro|no|
