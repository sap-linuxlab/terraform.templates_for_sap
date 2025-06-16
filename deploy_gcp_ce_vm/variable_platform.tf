
variable "gcp_project" {
  description = "Target GCP Project ID"
}

variable "gcp_region_zone" {
  description = "Target GCP Zone, the GCP Region will be calculated from this value (e.g. europe-west9-a)"
}

variable "gcp_credentials_json" {
  description = "Enter path to GCP Key File for Service Account (or Google Application Default Credentials JSON file for GCloud CLI)"
}

variable "gcp_vpc_subnet_name" {
  description = "Enter existing/target VPC Subnet name, or enter 'new' to create a VPC"
}

variable "resource_prefix" {
  description = "Prefix to resource names"
}
