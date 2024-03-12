variable "aws_region" {
  description = "AWS region where resources will be created"
  default     = "us-east-1"
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EKS resources will be created"
  type        = list(string)
  default     = ["subnet-0f78e4bde38e91494", "subnet-02b2e7bb4a58e380a"]
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS resources"
  type        = list(string)
  default     = ["sg-011da02532863fa97"]
}