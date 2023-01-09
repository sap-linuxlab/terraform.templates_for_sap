
variable "map_os_image_regex" {

  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-8-1 = "*RHEL-8.1*_HVM*x86_64*"

    rhel-8-2 = "*RHEL-8.2*_HVM*x86_64*"

    rhel-8-4 = "*RHEL-8.4*_HVM*x86_64*"

    rhel-8-6 = "*RHEL-8.6*_HVM*x86_64*"

    rhel-7-7-sap-ha = "*RHEL-SAP-7.7*"

    rhel-7-9-sap-ha = "*RHEL-SAP-7.9*"

    rhel-8-1-sap-ha = "*RHEL-SAP-8.1.0*"

    rhel-8-2-sap-ha = "*RHEL-SAP-8.2.0*"

    rhel-8-4-sap-ha = "*RHEL-SAP-8.4.0*"

    rhel-8-6-sap-ha = "*RHEL-SAP-8.6.0*"

    sles-15-2 = "*suse-sles-15-sp2-v202*-hvm-ssd-x86_64*"

    sles-15-3 = "*suse-sles-15-sp3-v202*-hvm-ssd-x86_64*"
  
    sles-15-4 = "*suse-sles-15-sp4-v202*-hvm-ssd-x86_64*"

    sles-12-5-sap-ha = "*suse-sles-sap-12-sp5-v202*-hvm-ssd-x86_64*"

    sles-15-1-sap-ha = "*suse-sles-sap-15-sp1-v202*-hvm-ssd-x86_64*"

    sles-15-2-sap-ha = "*suse-sles-sap-15-sp2-v202*-hvm-ssd-x86_64*"

    sles-15-3-sap-ha = "*suse-sles-sap-15-sp3-v202*-hvm-ssd-x86_64*"

    sles-15-4-sap-ha = "*suse-sles-sap-15-sp4-v202*-hvm-ssd-x86_64*"

  }

}
