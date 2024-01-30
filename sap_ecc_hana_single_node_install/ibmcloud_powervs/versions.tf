# Terraform declaration

terraform {
  required_version = ">= 1.0, <= 1.5.5"
  required_providers {
    ibm = {
      #source  = "localdomain/provider/ibm" // Local, on macOS path to place files would be $HOME/.terraform.d/plugins/localdomain/provider/ibm/1.xx.xx/darwin_amd6
      source  = "IBM-Cloud/ibm" // Terraform Registry
      version = ">=1.45.0"
    }
  }
}


# Terraform Provider declaration

provider "ibm" {

  alias = "standard"

  # Define Provider inputs manually
  #  ibmcloud_api_key = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # Define Provider inputs from given Terraform Variables
  ibmcloud_api_key = var.ibmcloud_api_key

  # If using IBM Cloud Automation Manager, the Provider declaration values are populated automatically
  # from the Cloud Connection credentials (by using Environment Variables)

  # If using IBM Cloud Schematics, the Provider declaration values are populated automatically

  region = local.ibmcloud_region

  zone = lower(var.ibmcloud_powervs_location) // Required for IBM Power VS only

}


provider "ibm" {

  alias = "powervs_secure"

  ibmcloud_api_key = var.ibmcloud_api_key

  region = local.ibmcloud_powervs_region

  zone = lower(var.ibmcloud_powervs_location) // Required for IBM Power VS only

}
