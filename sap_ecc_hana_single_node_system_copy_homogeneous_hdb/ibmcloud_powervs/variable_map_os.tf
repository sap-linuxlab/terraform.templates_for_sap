
variable "map_os_image_regex" {

  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    # OS Image keys for IBM Cloud Virtual Server (Bastion and Proxy)
    rhel-8-8 = ".*redhat.*8-8.*minimal.*amd64.*"
    rhel-8-10 = ".*redhat.*8-10.*minimal.*amd64.*"
    rhel-9-2 = ".*redhat.*9-2.*minimal.*amd64.*"
    rhel-9-4 = ".*redhat.*9-4.*minimal.*amd64.*"

    # OS Image keys for IBM Power Virtual Server
    rhel-8-4-sap-ha = "RHEL8-SP4-SAP"
    rhel-8-4-sap-ha-byol = "RHEL8-SP4-SAP-BYOL"
    rhel-8-6-sap-ha = "RHEL8-SP6-SAP"
    rhel-8-6-sap-ha-byol = "RHEL8-SP6-SAP-BYOL"
    rhel-8-8-sap-ha = "RHEL8-SP8-SAP"
    rhel-8-8-sap-ha-byol = "RHEL8-SP8-SAP-BYOL"
    rhel-9-2-sap-ha = "RHEL9-SP2-SAP"
    rhel-9-2-sap-ha-byol = "RHEL9-SP2-SAP-BYOL"

    sles-15-2-sap-ha = "SLES15-SP2-SAP"
    sles-15-2-sap-ha-byol = "SLES15-SP2-SAP-BYOL"
    sles-15-3-sap-ha = "SLES15-SP3-SAP"
    sles-15-3-sap-ha-byol = "SLES15-SP3-SAP-BYOL"
    sles-15-4-sap-ha = "SLES15-SP4-SAP"
    sles-15-4-sap-ha-byol = "SLES15-SP4-SAP-BYOL"
    sles-15-5-sap-ha = "SLES15-SP5-SAP"
    sles-15-5-sap-ha-byol = "SLES15-SP5-SAP-BYOL"

  }

}
