
# Terraform declaration
terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      #source  = "localdomain/provider/openstack" // Local, on macOS path to place files would be $HOME/.terraform.d/plugins/localdomain/provider/openstack/1.xx.xx/darwin_amd6
      source  = "terraform-provider-openstack/openstack"
      version = "1.45.0"
    }
  }
}


# Terraform Provider declaration
provider "openstack" {

  # Define Provider inputs from given Terraform Variables
  auth_url  = var.ibmpowervc_auth_endpoint
  user_name = var.ibmpowervc_user
  password  = var.ibmpowervc_user_password

  tenant_name = var.ibmpowervc_project_name
  #domain_name = "Default"
  insecure = true
}
