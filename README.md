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
