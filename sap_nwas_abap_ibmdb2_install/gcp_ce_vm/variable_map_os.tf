
# There is no Terraform Resource for data lookup of all GCP OS Images, therefore the input does not use wildcard

variable "map_os_image_regex" {

  description = "Map of operating systems OS Image, static OS Image names, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-8-latest = {
      project = "rhel-cloud"
      family  = "rhel-8"
    },

    rhel-7-7-sap-ha = {
      project = "rhel-sap-cloud"
      family  = "rhel-7-7-sap-ha"
    },

    rhel-7-9-sap-ha = {
      project = "rhel-sap-cloud"
      family  = "rhel-7-9-sap-ha"
    },

    rhel-8-1-sap-ha = {
      project = "rhel-sap-cloud"
      family  = "rhel-8-1-sap-ha"
    },

    rhel-8-2-sap-ha = {
      project = "rhel-sap-cloud"
      family  = "rhel-8-2-sap-ha"
    },

    rhel-8-4-sap-ha = {
      project = "rhel-sap-cloud"
      family  = "rhel-8-4-sap-ha"
    },

    rhel-8-6-sap-ha = {
      project = "rhel-sap-cloud"
      family  = "rhel-8-6-sap-ha"
    },

    sles-15-latest = {
      project = "suse-cloud"
      family  = "sles-15"
    },

    sles-12-sp5-sap = {
      project = "suse-sap-cloud"
      family  = "sles-12-sp5-sap"
    },

    sles-15-sp1-sap = {
      project = "suse-sap-cloud"
      family  = "sles-15-sp1-sap"
    },

    sles-15-sp2-sap = {
      project = "suse-sap-cloud"
      family  = "sles-15-sp2-sap"
    },

    sles-15-sp3-sap = {
      project = "suse-sap-cloud"
      family  = "sles-15-sp3-sap"
    },

    sles-15-sp4-sap = {
      project = "suse-sap-cloud"
      family  = "sles-15-sp4-sap"
    },

  }

}
