
variable "resource_prefix" {
  description = "Prefix to resource names"
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

variable "os_vendor_account_user" {
  description = "OS Vendor account email/username for Red Hat Customer Portal (RHCP) or SUSE Customer Center (SCC). ALT: if using os_systems_mgmt_host for Red Hat Satellite, this acts as Red Hat Org ID"
}

variable "os_vendor_account_user_passcode" {
  description = "OS Vendor passcode [password for Red Hat Customer Portal (RHCP), activation code for SUSE Customer Center (SCC)]. ALT: if using os_systems_mgmt_host for Red Hat Satellite, this acts as Red Hat Activation Key"
}

variable "os_systems_mgmt_host" {
  description = "OS Systems Management host for licensing (i.e. Red Hat Satellite). **Leave blank if using Red Hat Customer Portal (RHCP) or SUSE Customer Center (SCC)**"
}

variable "sap_software_download_directory" {
  description = "Mount point for downloads of SAP Software"

  validation {
    error_message = "Directory must start with forward slash."
    condition = can(regex("^/", var.sap_software_download_directory))
  }

}

variable "web_proxy_url" {
  description = "Web Proxy URL for hosts running on VMware vSphere (e.g. http://ip.v4.goes.here:port)"
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





variable "vmware_vcenter_user" {
  description = "Target vCenter: User (e.g. Administrator@vsphere.local)"
}

variable "vmware_vcenter_user_password" {
  description = "Target vCenter: User Password"
}

variable "vmware_vcenter_server" {
  description = "Target vCenter: Host Server FQDN (e.g. vcenter.domain.local)"
}

variable "vmware_vsphere_datacenter_name" {
  description = "Target vSphere Datacenter name"
}

variable "vmware_vsphere_datacenter_compute_cluster_name" {
  description = "Target vSphere Datacenter Compute Cluster name, to host the VMware Virtual Machine"
}

variable "vmware_vsphere_datacenter_compute_cluster_host_fqdn" {
  description = "Target vSphere Datacenter Compute specificed vSphere Host FQDN, to host the VMware Virtual Machine"
}

variable "vmware_vsphere_datacenter_compute_cluster_folder_name" {
  description = "Target vSphere Datacenter Compute Cluster Folder name, the logical directory for the VMware Virtual Machine"
}

variable "vmware_vsphere_datacenter_storage_datastore_name" {}

variable "vmware_vsphere_datacenter_network_primary_name" {}


variable "vmware_vm_template_name" {
  description = "VMware VM Template name to use for provisioning"
}
