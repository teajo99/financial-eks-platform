variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "project_name" {
  type        = string
}

variable "azs" {
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}