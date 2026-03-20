
variable "bastion_os_image" {
  description = "Bastion OS Image. This variable uses the locals mapping with regex of OS Images, and will alter bastion provisioning."
}

variable "host_os_image" {
  description = "Host OS Image. This variable uses the locals mapping with regex of OS Images, and will alter host provisioning."
}

# There is no Terraform Resource for data lookup of all GCP OS Images, therefore the input does not use wildcard

variable "map_os_image_regex" {

  description = "Map of operating systems OS Image, static OS Image names, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-8-latest = { project = "rhel-cloud" , family  = "rhel-8" },
    rhel-9-latest = { project = "rhel-cloud" , family  = "rhel-9" },
    rhel-10-latest = { project = "rhel-cloud" , family  = "rhel-10" },

    sles-12-latest = { project = "suse-cloud" , family  = "sles-12" },
    sles-15-latest = { project = "suse-cloud" , family  = "sles-15" },
    sles-16-latest = { project = "suse-cloud" , family  = "sles-16" },

    # rhel-7-7-sap-ha = { project = "rhel-sap-cloud" , family  = "rhel-7-7-sap-ha" }, // removed
    rhel-7-9-sap-ha = { project = "rhel-sap-cloud" , family  = "rhel-7-9-sap-ha" },
    # rhel-8-1-sap-ha = { project = "rhel-sap-cloud" , family  = "rhel-8-1-sap-ha" }, // removed
    rhel-8-2-sap-ha = { project = "rhel-sap-cloud" , family  = "rhel-8-2-sap-ha" },
    rhel-8-4-sap-ha = { project = "rhel-sap-cloud" , family  = "rhel-8-4-sap-ha" },
    rhel-8-6-sap-ha = { project = "rhel-sap-cloud" , family  = "rhel-8-6-sap-ha" },

    sles-12-5-sap-ha = { project = "suse-sap-cloud" , family  = "sles-12-sp5-sap" },
    # sles-15-1-sap-ha = { project = "suse-sap-cloud" , family  = "sles-15-sp1-sap" }, // removed
    sles-15-2-sap-ha = { project = "suse-sap-cloud" , family  = "sles-15-sp2-sap" },
    sles-15-3-sap-ha = { project = "suse-sap-cloud" , family  = "sles-15-sp3-sap" },
    sles-15-4-sap-ha = { project = "suse-sap-cloud" , family  = "sles-15-sp4-sap" },
    sles-15-5-sap-ha = { project = "suse-sap-cloud" , family  = "sles-15-sp5-sap" }
    sles-15-6-sap-ha = { project = "suse-sap-cloud" , family  = "sles-15-sp6-sap" }

  }

}
