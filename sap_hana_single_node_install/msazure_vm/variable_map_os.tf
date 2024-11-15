
variable "map_os_image_regex" {

  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-8-0  = { publisher = "RedHat" , offer = "RHEL" , sku = "8-gen2" },
    rhel-8-1  = { publisher = "RedHat" , offer = "RHEL" , sku = "81gen2" },
    rhel-8-2  = { publisher = "RedHat" , offer = "RHEL" , sku = "82gen2" },
    rhel-8-3  = { publisher = "RedHat" , offer = "RHEL" , sku = "83-gen2" },
    rhel-8-4  = { publisher = "RedHat" , offer = "RHEL" , sku = "84-gen2" },
    rhel-8-5  = { publisher = "RedHat" , offer = "RHEL" , sku = "85-gen2" },
    rhel-8-6  = { publisher = "RedHat" , offer = "RHEL" , sku = "86-gen2" },
    rhel-8-7  = { publisher = "RedHat" , offer = "RHEL" , sku = "87-gen2" },
    rhel-8-8  = { publisher = "RedHat" , offer = "RHEL" , sku = "88-gen2" },
    rhel-8-9  = { publisher = "RedHat" , offer = "RHEL" , sku = "89-gen2" },
    rhel-8-10 = { publisher = "RedHat" , offer = "RHEL" , sku = "810-gen2" },
    rhel-9-0  = { publisher = "RedHat" , offer = "RHEL" , sku = "90-gen2" },
    rhel-9-1  = { publisher = "RedHat" , offer = "RHEL" , sku = "91-gen2" },
    rhel-9-2  = { publisher = "RedHat" , offer = "RHEL" , sku = "92-gen2" },
    rhel-9-3  = { publisher = "RedHat" , offer = "RHEL" , sku = "93-gen2" },
    rhel-9-4  = { publisher = "RedHat" , offer = "RHEL" , sku = "94-gen2" },

    rhel-8-1-sap-ha  = { publisher = "RedHat" , offer = "RHEL-SAP-HA" , sku = "81sapha-gen2" },
    rhel-8-2-sap-ha  = { publisher = "RedHat" , offer = "RHEL-SAP-HA" , sku = "82sapha-gen2" },
    rhel-8-4-sap-ha  = { publisher = "RedHat" , offer = "RHEL-SAP-HA" , sku = "84sapha-gen2" },
    rhel-8-6-sap-ha  = { publisher = "RedHat" , offer = "RHEL-SAP-HA" , sku = "86sapha-gen2" },
    rhel-8-8-sap-ha  = { publisher = "RedHat" , offer = "RHEL-SAP-HA" , sku = "88sapha-gen2" },
    rhel-8-10-sap-ha = { publisher = "RedHat" , offer = "RHEL-SAP-HA" , sku = "810sapha-gen2" },
    rhel-9-0-sap-ha  = { publisher = "RedHat" , offer = "RHEL-SAP-HA" , sku = "90sapha-gen2" },
    rhel-9-2-sap-ha  = { publisher = "RedHat" , offer = "RHEL-SAP-HA" , sku = "92sapha-gen2" },
    rhel-9-4-sap-ha  = { publisher = "RedHat" , offer = "RHEL-SAP-HA" , sku = "94sapha-gen2" },

    sles-12-5 = { publisher = "SUSE" , offer = "sles-12-sp5" , sku = "gen2" },
    sles-15-1 = { publisher = "SUSE" , offer = "sles-15-sp1" , sku = "gen2" },
    sles-15-2 = { publisher = "SUSE" , offer = "sles-15-sp2" , sku = "gen2" },
    sles-15-3 = { publisher = "SUSE" , offer = "sles-15-sp3" , sku = "gen2" },
    sles-15-4 = { publisher = "SUSE" , offer = "sles-15-sp4" , sku = "gen2" },
    sles-15-5 = { publisher = "SUSE" , offer = "sles-15-sp5" , sku = "gen2" },
    sles-15-6 = { publisher = "SUSE" , offer = "sles-15-sp6" , sku = "gen2" },

    sles-12-5-sap-ha = { publisher = "SUSE" , offer = "sles-sap-12-sp5" , sku = "gen2" },
    sles-15-1-sap-ha = { publisher = "SUSE" , offer = "sles-sap-15-sp1" , sku = "gen2" },
    sles-15-2-sap-ha = { publisher = "SUSE" , offer = "sles-sap-15-sp2" , sku = "gen2" },
    sles-15-3-sap-ha = { publisher = "SUSE" , offer = "sles-sap-15-sp3" , sku = "gen2" },
    sles-15-4-sap-ha = { publisher = "SUSE" , offer = "sles-sap-15-sp4" , sku = "gen2" },
    sles-15-5-sap-ha = { publisher = "SUSE" , offer = "sles-sap-15-sp5" , sku = "gen2" },
    sles-15-6-sap-ha = { publisher = "SUSE" , offer = "sles-sap-15-sp6" , sku = "gen2" }

  }

}
