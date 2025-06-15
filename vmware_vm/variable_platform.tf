
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

variable "resource_prefix" {
  description = "Prefix to resource names"
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

variable "web_proxy_url" {
  description = "Web Proxy URL for hosts running on VMware vSphere (e.g. http://ip.v4.goes.here:port)"
}
