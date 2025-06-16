
variable "az_tenant_id" {
  description = "Azure Tenant ID"
}

variable "az_subscription_id" {
  description = "Azure Subscription ID"
}

variable "az_app_client_id" {
  description = "Azure AD App Client ID"
}

variable "az_app_client_secret" {
  description = "Azure AD App Client Secret"
}

variable "resource_prefix" {
  description = "Enter prefix to resource names"
}

variable "az_resource_group_name" {
  description = "Enter existing/target Azure Resource Group name, or enter 'new' to create a Resource Group using the defined prefix for all resources"
}

variable "az_location_region" {
  description = "Target Azure Region aka. Azure Location Display Name (e.g. 'West Europe')"
}

variable "az_location_availability_zone_no" {
  description = "Target Azure Availability Zone (e.g. 1)"
}

variable "az_vnet_name" {
  description = "Enter existing/target Azure VNet name, or enter 'new' to create a VPC with a default VPC Address Prefix Range (cannot be 'new' if using existing VNet Subnet)"
}

variable "az_vnet_subnet_name" {
  description = "Enter existing/target Azure VNet Subnet name, or enter 'new' to create a VPC with a default VPC Address Prefix Range (if using existing VNet, ensure default subnet range matches to VNet address space and does not conflict with existing Subnet)"
}
