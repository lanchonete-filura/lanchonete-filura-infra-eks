variable "aws_region" {
  description = "AWS region where resources will be created"
  default     = "us-east-1"
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EKS resources will be created"
  type        = list(string)
  default     = ["subnet-0014a51e3d2b3c8e8"]
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS resources"
  type        = list(string)
  default     = ["sg-056ab5fe5d2762eb5"]
}