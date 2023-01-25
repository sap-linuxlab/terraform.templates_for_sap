
# Terraform declaration
terraform {
  required_version = ">= 1.0"
  required_providers {
    vsphere = {
#      source  = "localdomain/provider/vsphere" // Local, on macOS path to place files would be $HOME/.terraform.d/plugins/localdomain/provider/vsphere/1.xx.xx/darwin_amd6
      source = "hashicorp/vsphere"
      version = ">=2.2.0"
    }
  }
}


# Terraform Provider declaration
provider "vsphere" {

  # Define Provider inputs from given Terraform Variables
  user           = var.vmware_vcenter_user
  password       = var.vmware_vcenter_user_password
  vsphere_server = var.vmware_vcenter_server

  # Self-signed certificate
  allow_unverified_ssl = true

}
