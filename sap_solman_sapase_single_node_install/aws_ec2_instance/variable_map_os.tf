
variable "map_os_image_regex" {

  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-8-1 = "*RHEL-8.1*_HVM*x86_64*"
    # rhel-8-2 = "*RHEL-8.2*_HVM*x86_64*" // removed
    rhel-8-4 = "*RHEL-8.4*_HVM*x86_64*"
    rhel-8-6 = "*RHEL-8.6*_HVM*x86_64*"
    rhel-8-8 = "*RHEL-8.8*_HVM*x86_64*"
    rhel-8-10 = "*RHEL-8.10*_HVM*x86_64*"
    rhel-9-0 = "*RHEL-9.0*_HVM*x86_64*"
    rhel-9-1 = "*RHEL-9.1*_HVM*x86_64*"
    rhel-9-2 = "*RHEL-9.2*_HVM*x86_64*"
    rhel-9-3 = "*RHEL-9.3*_HVM*x86_64*"
    rhel-9-4 = "*RHEL-9.4*_HVM*x86_64*"

    # rhel-7-7-sap-ha = "*RHEL-SAP-7.7*" // removed
    # rhel-7-9-sap-ha = "*RHEL-SAP-7.9*" // removed
    rhel-8-1-sap-ha = "*RHEL-SAP-8.1.0*"
    rhel-8-2-sap-ha = "*RHEL-SAP-8.2.0*"
    rhel-8-4-sap-ha = "*RHEL-SAP-8.4.0*"
    rhel-8-6-sap-ha = "*RHEL-SAP-8.6.0*"
    rhel-8-8-sap-ha = "*RHEL-SAP-8.8.0*"
    rhel-8-10-sap-ha = "*RHEL-SAP-8.10.0*"

    sles-12-5 = "*suse-sles-12-sp5-v202*-hvm-ssd-x86_64*"
    # sles-15-2 = "*suse-sles-15-sp2-v202*-hvm-ssd-x86_64*" // removed
    # sles-15-3 = "*suse-sles-15-sp3-v202*-hvm-ssd-x86_64*" // removed
    # sles-15-4 = "*suse-sles-15-sp4-v202*-hvm-ssd-x86_64*" // removed
    sles-15-5 = "*suse-sles-15-sp5-v202*-hvm-ssd-x86_64*"
    sles-15-6 = "*suse-sles-15-sp6-v202*-hvm-ssd-x86_64*"

    sles-12-5-sap-ha = "*suse-sles-sap-12-sp5-v202*-hvm-ssd-x86_64*"
    sles-15-1-sap-ha = "*suse-sles-sap-15-sp1-v202*-hvm-ssd-x86_64*"
    sles-15-2-sap-ha = "*suse-sles-sap-15-sp2-v202*-hvm-ssd-x86_64*"
    sles-15-3-sap-ha = "*suse-sles-sap-15-sp3-v202*-hvm-ssd-x86_64*"
    sles-15-4-sap-ha = "*suse-sles-sap-15-sp4-v202*-hvm-ssd-x86_64*"
    sles-15-5-sap-ha = "*suse-sles-sap-15-sp5-v202*-hvm-ssd-x86_64*"
    sles-15-6-sap-ha = "*suse-sles-sap-15-sp6-v202*-hvm-ssd-x86_64*"

  }

}
