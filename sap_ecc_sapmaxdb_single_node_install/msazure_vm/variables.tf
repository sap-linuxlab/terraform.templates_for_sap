
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

variable "dns_root_domain" {
  description = "Root Domain for Private DNS used with the Virtual Machine"
}

variable "bastion_os_image" {
  description = "Bastion OS Image. This variable uses the locals mapping with regex of OS Images, and will alter bastion provisioning."
}

variable "bastion_user" {
  description = "OS User to create on Bastion host to avoid pass-through root user (e.g. bastionuser)"
}

variable "bastion_ssh_port" {
  type        = number
  description = "Bastion host SSH Port from IANA Dynamic Ports range (49152 to 65535)"

  validation {
    condition     = var.bastion_ssh_port > 49152 && var.bastion_ssh_port < 65535
    error_message = "Bastion host SSH Port must fall within IANA Dynamic Ports range (49152 to 65535)."
  }
}

variable "host_specification_plan" {
  description = "Host specification plans are small_32vcpu. This variable uses the locals mapping with a nested list of host specifications, and will alter host provisioning."
}

variable "host_os_image" {
  description = "Host OS Image. This variable uses the locals mapping with regex of OS Images, and will alter host provisioning."
}

variable "disk_volume_capacity_software" {
  type        = number
  description = "Disk volume capacity for downloads of SAP Software"
}

variable "sap_software_download_directory" {
  description = "Mount point for downloads of SAP Software"

  validation {
    error_message = "Directory must start with forward slash."
    condition = can(regex("^/", var.sap_software_download_directory))
  }

}



variable "sap_id_user" {
  description = "Ansible - Please enter your SAP ID user (e.g. S-User)"
}

variable "sap_id_user_password" {
  description = "Ansible - Please enter your SAP ID password"
}

variable "sap_anydb_install_master_password" {
  description = "Ansible - SAP AnyDB install: set common initial password (e.g. NewPass$321)"
}

variable "sap_anydb_install_sid" {
  description = "Ansible - SAP AnyDB install: System ID (e.g. MX1)"
}

variable "sap_anydb_install_instance_number" {
  description = "Ansible - SAP AnyDB install: Instance Number (e.g. 90)"
}

variable "sap_ecc_install_sid" {
  description = "Ansible - SAP ECC install: System ID (e.g. E01)"
}

variable "sap_swpm_template_selected" {
  description = "Ansible - Select template to use: sap_ecc6_ehp8_sapmaxdb_onehost"
}

variable "sap_nwas_abap_ascs_instance_no" {
  description = "Ansible - SAP NetWeaver AS (ABAP) - ABAP Central Services (ASCS) instance number"

  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_nwas_abap_ascs_instance_no))
  }

}

variable "sap_nwas_abap_pas_instance_no" {
  description = "Ansible - SAP NetWeaver AS (ABAP) - Primary Application Server instance number"

  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_nwas_abap_pas_instance_no))
  }

}
