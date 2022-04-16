
variable "ibmpowervc_auth_endpoint" {
  description = "IBM PowerVC: Authentication Endpoint (e.g. https://powervc-host:5000/v3/)"
}

variable "ibmpowervc_user" {
  description = "IBM PowerVC: Username"
}

variable "ibmpowervc_user_password" {
  description = "IBM PowerVC: User Password"
}

variable "resource_prefix" {
  description = "Prefix to resource names"
}

variable "ibmpowervc_project_name" {
  description = "IBM PowerVC: Project Name"
}

variable "ibmpowervc_host_group_name" {
  description = "IBM PowerVC: Host Group Name"
}

variable "ibmpowervc_network_name" {
  description = "IBM PowerVC: Network Name"
}

variable "ibmpowervc_template_compute_name" {
  description = "IBM PowerVC: Enter 'new' to create a Compute Template from the CPU and RAM in the host specification plan, or use an existing/target Compute Template Name"
}

variable "ibmpowervc_storage_storwize_hostname_short" {
  description = "IBM PowerVC - Storage with IBM Storwize: Hostname short (e.g. v7000)"
}

variable "ibmpowervc_storage_storwize_storage_pool" {
  description = "IBM PowerVC - Storage with IBM Storwize: Storage Pool (e.g. V7000_01)"
}

variable "ibmpowervc_storage_storwize_storage_pool_flash" {
  description = "IBM PowerVC - Storage with IBM Storwize: Storage Pool with Flash Storage (e.g. FS900_01)"
}

variable "dns_root_domain" {
  description = "Root Domain to be used with the host"
}

variable "bastion_boolean" {
  description = "Bastion connection required? (boolean default: false)"
  default     = false
}

variable "bastion_user" {
  description = "OS User to create on Bastion host to avoid pass-through root user (e.g. bastionuser)"
  default     = ""
}

variable "bastion_ip" {
  description = "Bastion IP address (IPv4)"
  default     = ""
}

variable "bastion_private_ssh_key" {
  description = "Private SSH Key string"
  default     = ""
}

variable "bastion_ssh_port" {
  type        = number
  description = "Bastion host SSH Port from IANA Dynamic Ports range (49152 to 65535)"
  default     = null

  #validation {
  #  condition     = var.bastion_ssh_port > 49152 && var.bastion_ssh_port < 65535
  #  error_message = "Bastion host SSH Port must fall within IANA Dynamic Ports range (49152 to 65535)."
  #}
}

variable "host_specification_plan" {
  description = "Host specification plans are small_256gb. This variable uses the locals mapping with a nested list of host specifications, and will alter host provisioning."
}

variable "ibmpowervc_os_image_name" {
  description = "IBM PowerVC: OS Image Name"
}

variable "os_vendor_account_user" {
  description = "OS Vendor account email/username for Red Hat Customer Portal (RHCP) or SUSE Customer Center (SCC). ALT: if using os_systems_mgmt_host for Red Hat Satellite, this acts as Red Hat Org ID"
}

variable "os_vendor_account_user_passcode" {
  description = "OS Vendor passcode [password for Red Hat Customer Portal (RHCP), activation code for SUSE Customer Center (SCC)]. ALT: if using os_systems_mgmt_host for Red Hat Satellite, this acts as Red Hat Activation Key"
}

variable "os_systems_mgmt_host" {
  description = "OS Systems Management host for licensing (i.e. Red Hat Satellite). **Leave blank if using Red Hat Customer Portal (RHCP) or SUSE Customer Center (SCC)**"
}

variable "disk_volume_capacity_software" {
  description = "Disk volume for downloads of SAP Software and any backup files"
}

variable "sap_software_download_directory" {
  description = "Mount point for downloads of SAP Software and any backup files"
}

variable "web_proxy_url" {
  description = "Web Proxy URL for hosts running on IBM Power (e.g. http://ip.v4.goes.here:port)"
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
