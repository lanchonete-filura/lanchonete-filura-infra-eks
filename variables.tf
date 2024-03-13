variable "aws_region" {
  description = "AWS region where resources will be created"
  default     = "us-east-1"
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EKS resources will be created"
  type        = list(string)
  default     = ["subnet-0ef38734aad4da192", "subnet-0513c50b1551cb707"]
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS resources"
  type        = list(string)
  default     = ["sg-04605dc7858bb07d6"]
}