variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region where the resources must be created"

  validation {
    condition     = contains(["us-east-1", "us-west-1", "ap-southeast-2"], var.aws_region)
    error_message = "Please select the regions us-east-1 or us-west-2 or ap-southeast-2."
  }
}

variable "dept" {
  type        = string
  default     = ""
  description = "Department that owns the resource"
}