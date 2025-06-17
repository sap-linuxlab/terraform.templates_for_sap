
variable "ibmcloud_api_key" {
  description = "Enter your IBM Cloud API Key"
}

variable "resource_tags" {
  type        = list(string)
  description = "Tags applied to each resource created"
}

variable "resource_prefix" {
  description = "Prefix to resource names"
}

variable "ibmcloud_resource_group" {
  description = "Enter existing/target Resource Group name, or enter 'new' to create a Resource Group using the defined prefix for all resources"
}

variable "ibmcloud_powervs_location" {
  description = "Target IBM Power VS location (e.g. lon06). Each location is colocated at a IBM Cloud VPC Infrastructure Availability Zone (e.g. eu-gb-3)"
}

#variable "ibmcloud_iam_yesno" {
#  description = "Please choose 'yes' or 'no' for setup of default IBM Cloud Identity and Access Management (IAM) controls, for use by technicians to view and edit resources of SAP Systems run on IBM Cloud (NOTE: Requires admin privileges on API Key)"
#}

variable "ibmcloud_vpc_subnet_name" {
  description = "Enter existing/target VPC Subnet name , or enter 'new' to create a VPC with a default VPC Address Prefix Range. If using an existing VPC Subnet, it must be attached to a Public Gateway (i.e. SNAT)"
}

variable "os_vendor_account_user" {
  description = "OS Vendor (Red Hat or SUSE) account email/username"
}

variable "os_vendor_account_user_passcode" {
  description = "OS Vendor passcode (password for Red Hat, activation code for SUSE)"
}
