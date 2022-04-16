
variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "resource_prefix" {
  description = "Prefix to resource names"
}

variable "aws_region" {
  description = "AWS Region"
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

  #validation {
  #  condition     = var.bastion_ssh_port > 49152 && var.bastion_ssh_port < 65535
  #  error_message = "Bastion host SSH Port must fall within IANA Dynamic Ports range (49152 to 65535)."
  #}
}

variable "host_specification_plan" {
  description = "Host specification plans are small_256gb, small_256gb_ha. This variable uses the locals mapping with a nested list of host specifications, and will alter host provisioning."
}

variable "host_os_image" {
  description = "Host OS Image. This variable uses the locals mapping with regex of OS Images, and will alter host provisioning."
}

variable "disk_volume_capacity_software" {
  description = "Disk volume capacity for downloads of SAP Software and any backup files"
}

variable "disk_volume_type_software" {
  description = "Disk volume type for downloads of SAP Software and any backup files"
}

variable "sap_software_download_directory" {
  description = "Mount point for downloads of SAP Software and any backup files"
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
  description = "Ansible - SAP HANA install: Instance Number (e.g. 00)"
}

variable "sap_s4hana_install_sid" {
  description = "Ansible - SAP S/4HANA install: System ID (e.g. S01)"
}

variable "sap_maintenance_planner_transaction_name" {
  description = "Ansible - SAP Maintenance Planner Transaction name for SAP S/4HANA, required to perform download of this stack"
}

variable "sap_swpm_template_selected" {
  description = "Ansible - Select template to use: sap_s4hana_2020_onehost_install, sap_s4hana_2021_onehost_install"
}

variable "sap_nwas_pas_instance_no" {
  description = "Ansible - SAP NetWeaver AS (ABAP) - Primary Application Server instance number"
}
