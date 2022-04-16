
variable "map_os_image_regex" {

  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-8-4 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "84-gen2"
    },

    rhel-8-1-sap-hana = {
      publisher = "RedHat"
      offer     = "RHEL-SAP-HA"
      sku       = "81sapha-gen2"
    },

    rhel-8-2-sap-hana = {
      publisher = "RedHat"
      offer     = "RHEL-SAP-HA"
      sku       = "82sapha-gen2"
    },

    rhel-8-4-sap-hana = {
      publisher = "RedHat"
      offer     = "RHEL-SAP-HA"
      sku       = "84sapha-gen2"
    },

    rhel-8-1-sap-applications = {
      publisher = "RedHat"
      offer     = "RHEL-SAP-APPS"
      sku       = "81sapapps-gen2"
    },

    rhel-8-2-sap-applications = {
      publisher = "RedHat"
      offer     = "RHEL-SAP-APPS"
      sku       = "82sapapps-gen2"
    },

    rhel-8-4-sap-applications = {
      publisher = "RedHat"
      offer     = "RHEL-SAP-APPS"
      sku       = "84sapapps-gen2"
    },

    sles-12-sp5-sap = {
      publisher = "SUSE"
      offer     = "sles-sap-12-sp5"
      sku       = "gen2"
    },

    sles-15-sp1-sap = {
      publisher = "SUSE"
      offer     = "sles-sap-15-sp1"
      sku       = "gen2"
    },

    sles-15-sp2-sap = {
      publisher = "SUSE"
      offer     = "sles-sap-15-sp2"
      sku       = "gen2"
    },

    sles-15-sp3-sap = {
      publisher = "SUSE"
      offer     = "sles-sap-15-sp3"
      sku       = "gen2"
    }

  }

}
