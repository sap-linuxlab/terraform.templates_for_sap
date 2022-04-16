
variable "map_os_image_regex" {

  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-7-6-sap = "*SAP-7.6*"

    rhel-7-7-sap = "*RHEL-SAP-7.7*"

    rhel-7-9-sap = "*RHEL-SAP-7.9*"

    rhel-8-1-sap = "*RHEL-8.1.0-SAP*"

    rhel-8-2-sap = "*RHEL-8.2.0-SAP*"

    sles-12-5-sap = ".*suse-sles-12-sp5-v202.*-hvm-ssd-x86_64.*"

    sles-15-1-sap = ".*suse-sles-15-sp1-v202*-hvm-ssd-x86_64.*"

    sles-15-2-sap = ".*suse-sles-15-sp2-v202*-hvm-ssd-x86_64.*"

    sles-15-3-sap = ".*suse-sles-15-sp3-v202*-hvm-ssd-x86_64.*"

  }

}
