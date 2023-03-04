
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

variable "ibmcloud_vpc_availability_zone" {
  description = "Target IBM Cloud Availability Zone (e.g. us-south-1). The IBM Cloud Region will be calculated from this value"

  validation {
    error_message = "Please enter an IBM Cloud Availability Zone (e.g. us-south-1)."
    condition = can(regex("^([a-zA-Z0-9]*-[a-zA-Z0-9]*){2}$", var.ibmcloud_vpc_availability_zone))
  }

}

#variable "ibmcloud_iam_yesno" {
#  description = "Please choose 'yes' or 'no' for setup of default IBM Cloud Identity and Access Management (IAM) controls, for use by technicians to view and edit resources of SAP Systems run on IBM Cloud (NOTE: Requires admin privileges on API Key)"
#}

variable "ibmcloud_vpc_subnet_name" {
  description = "Enter existing/target VPC Subnet name, or enter 'new' to create a VPC with a default VPC Address Prefix Range. If using an existing VPC Subnet, it must be attached to a Public Gateway (i.e. SNAT)"
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

  validation {
    condition     = var.bastion_ssh_port > 49152 && var.bastion_ssh_port < 65535
    error_message = "Bastion host SSH Port must fall within IANA Dynamic Ports range (49152 to 65535)."
  }
}

variable "host_specification_plan" {
  description = "Host specification plans are small_256gb. This variable uses the locals mapping with a nested list of host specifications, and will alter host provisioning."
}

variable "host_os_image" {
  description = "Host OS Image. This variable uses the locals mapping with regex of OS Images, and will alter host provisioning."
}

variable "disk_volume_capacity_software" {
  type        = number
  description = "Disk volume capacity for downloads of SAP Software and any backup files"
}

variable "disk_volume_type_software" {
  description = "Disk volume type for downloads of SAP Software and any backup files"
}

variable "sap_software_download_directory" {
  description = "Mount point for downloads of SAP Software"

  validation {
    error_message = "Directory must start with forward slash."
    condition = can(regex("^/", var.sap_software_download_directory))
  }

}

variable "ibmcos_bucket" {
  description = "IBM Cloud Object Storage bucket name, containing the SAP HANA Database backup files. Optional prefix (e.g. bucketname/prefix)"
}



variable "sap_id_user" {
  description = "Ansible - Please enter your SAP ID user (e.g. S-User)"
}

variable "sap_id_user_password" {
  description = "Ansible - Please enter your SAP ID password"
}

variable "sap_hana_install_master_password" {
  description = "Ansible - SAP HANA install: set common initial password (e.g. NewPass$321)"
}

variable "sap_hana_install_sid" {
  description = "Ansible - SAP HANA install: System ID (e.g. H01)"
}

variable "sap_hana_install_instance_number" {
  description = "Ansible - SAP HANA install: Instance Number (e.g. 90)"

  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_hana_install_instance_number))
  }

}

variable "sap_ecc_hana_install_sid" {
  description = "Ansible - SAP ECC on HANA install: System ID (e.g. E01)"
}

variable "sap_hana_backup_directory" {
  description = "Ansible - SAP HANA backup file directory (on remote host), for SWPM System Copy Homogeneous (from SAP HANA Backup/Restore). No trailing forward slash)"
}

variable "sap_hana_backup_filename_prefix" {
  description = "Ansible - SAP HANA backup filename (on remote host), for SWPM System Copy Homogeneous (from SAP HANA Backup/Restore)"
}

variable "sap_hana_backup_db_schema_to_swpm" {
  description = "Ansible - DB Schema name inside the SAP HANA backup, for restore execution by SAP SWPM"
}

variable "sap_swpm_backup_system_password" {
  description = "Ansible - SAP NetWeaver Password of user 'SYSTEM' inside the HANA database tenant from a backup. Password is determined by backup file."
}

variable "sap_swpm_db_schema_abap_password" {
  description = "Ansible - SAP HANA Password of the database schema used in the backup file. Password is determined by backup file."
}

variable "sap_swpm_ddic_000_password" {
  description = "Ansible - SAP NetWeaver Data Dictionary (DDIC) user password in client 000. Password is determined by backup file."
}

variable "sap_swpm_template_selected" {
  description = "Ansible - Select template to use: sap_ecc6_ehp7_hana_onehost_system_copy"
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
