
variable "map_os_image_regex" {

  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-8-4 = ".*redhat.*8-4.*minimal.*amd64.*"

    rhel-8-1-power-sap-byol = "Linux-RHEL-SAP-8-1"

    sles-12-4-power-sap-byol = "Linux-SUSE-SAP-12-4"

  }

}
