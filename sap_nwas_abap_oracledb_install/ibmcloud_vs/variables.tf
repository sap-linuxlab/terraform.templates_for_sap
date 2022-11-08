
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

variable "ibmcloud_region" {
  description = "Target Region"
}

variable "ibmcloud_iam_yesno" {
  description = "Please choose 'yes' or 'no' for setup of default IBM Cloud Identity and Access Management (IAM) controls, for use by technicians to view and edit resources of SAP Systems run on IBM Cloud (NOTE: Requires admin privileges on API Key)"
}

variable "ibmcloud_vpc_subnet_name" {
  description = "Enter existing/target VPC Subnet name, or enter 'new' to create a VPC with a default VPC Address Prefix Range"
}

variable "dns_root_domain" {
  description = "Root Domain for Private DNS used with the Virtual Server"
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

  #validation {
  #  condition     = var.bastion_ssh_port > 49152 && var.bastion_ssh_port < 65535
  #  error_message = "Bastion host SSH Port must fall within IANA Dynamic Ports range (49152 to 65535)."
  #}
}

variable "host_specification_plan" {
  description = "Host specification plans are small_32vcpu. This variable uses the locals mapping with a nested list of host specifications, and will alter host provisioning."
}

variable "host_os_image" {
  description = "Host OS Image. This variable uses the locals mapping with regex of OS Images, and will alter host provisioning."
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
  description = "Ansible - SAP AnyDB install: System ID (e.g. OR1)"
}

variable "sap_anydb_install_instance_number" {
  description = "Ansible - SAP AnyDB install: Instance Number (e.g. 90)"

  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_anydb_install_instance_number))
  }

}


variable "sap_swpm_template_selected" {
  description = "Ansible - Select template to use: sap_nwas_752_sp00_abap_oracledb_onehost, sap_nwas_750_sp00_abap_oracledb_onehost"
}

variable "sap_nwas_install_sid" {
  description = "Ansible - SAP NetWeaver install: System ID (e.g. N01)"
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
