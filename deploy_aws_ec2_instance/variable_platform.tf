
variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "resource_prefix" {
  description = "Prefix to resource names"
}

variable "aws_vpc_availability_zone" {
  description = "Target AWS VPC Availability Zone (the AWS Region will be calculated from this value)"
}

variable "aws_vpc_subnet_id" {
  description = "Enter existing/target VPC Subnet ID, or enter 'new' to create a VPC with a default VPC prefix range"
}
