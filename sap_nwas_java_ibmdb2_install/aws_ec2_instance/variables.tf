
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
  description = "Ansible - SAP AnyDB install: set common initial password (e.g. NewPass@321)"
}

variable "sap_anydb_install_sid" {
  description = "Ansible - SAP AnyDB install: System ID (e.g. AS1)"
}

variable "sap_anydb_install_instance_number" {
  description = "Ansible - SAP AnyDB install: Instance Number (e.g. 90)"

  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_anydb_install_instance_number))
  }

}


variable "sap_swpm_template_selected" {
  description = "Ansible - Select template to use: sap_nwas_750_sp22_java_ibmdb2_onehost_ads"
}

variable "sap_nwas_install_sid" {
  description = "Ansible - SAP NetWeaver AS (ABAP) install: System ID (e.g. N01)"
}

variable "sap_nwas_java_ci_instance_no" {
  description = "Ansible - SAP NetWeaver AS (JAVA) - JAVA Central Instance (CI) instance number"

  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_nwas_java_ci_instance_no))
  }

}
