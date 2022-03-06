variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region where the resources must be created"

  validation {
    condition     = contains(["us-east-1", "us-west-1", "ap-southeast-2"], var.aws_region)
    error_message = "Please select the regions us-east-1 or us-west-2 or ap-southeast-2."
  }
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "Subnet for VPC Addresses"
}

variable "subnet_cidrs" {
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  description = "Subnet addresses for each subnet to be created"

  validation {
    condition     = length(var.subnet_cidrs) > 0
    error_message = "Please provide at least one availability zone."
  }

}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "List of availability Zones where the resources will be created"

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "Please provide at least one availability zone."
  }

}

variable "dept" {
  type        = string
  default     = "TEST"
  description = "Department that owns the resource"

}

variable "owner" {
  type        = string
  default     = "Jibin Antony"
  description = "Owner who creates the resources"
}

variable "sg_whitelist" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of IP address ranges to whitelist to access the webserver"

  validation {
    condition     = length(var.sg_whitelist) > 0
    error_message = "Please provide at least one subnet / IP address to whitelist."
  }
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type to be built"
}
