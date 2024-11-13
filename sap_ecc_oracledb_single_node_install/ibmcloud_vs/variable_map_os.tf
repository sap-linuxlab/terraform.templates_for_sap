
variable "map_os_image_regex" {

  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-8-8 = ".*redhat.*8-8.*minimal.*amd64.*"
    rhel-8-10 = ".*redhat.*8-10.*minimal.*amd64.*"
    rhel-9-2 = ".*redhat.*9-2.*minimal.*amd64.*"
    rhel-9-4 = ".*redhat.*9-4.*minimal.*amd64.*"

    # rhel-7-6-sap-ha = ".*redhat.*7-6.*amd64.*hana.*" // retrievable from deprecated list
    # rhel-7-9-sap-ha = ".*redhat.*7-9.*amd64.*hana.*" // retrievable from deprecated list
    # rhel-8-1-sap-ha = ".*redhat.*8-1.*amd64.*hana.*" // retrievable from deprecated list
    # rhel-8-2-sap-ha = ".*redhat.*8-2.*amd64.*hana.*" // retrievable from deprecated list
    rhel-8-4-sap-ha = ".*redhat.*8-4.*amd64.*hana.*"
    rhel-8-6-sap-ha = ".*redhat.*8-6.*amd64.*hana.*"
    rhel-8-8-sap-ha = ".*redhat.*8-8.*amd64.*hana.*"
    rhel-8-10-sap-ha = ".*redhat.*8-10.*amd64.*hana.*"
    rhel-9-0-sap-ha = ".*redhat.*9-0.*amd64.*hana.*"
    rhel-9-2-sap-ha = ".*redhat.*9-2.*amd64.*hana.*"
    rhel-9-4-sap-ha = ".*redhat.*9-4.*amd64.*hana.*"

    sles-15-2 = ".*sles.*15-5.*amd64-[0-9]"
    sles-15-2 = ".*sles.*15-6.*amd64-[0-9]"

    # sles-12-4-sap-ha = ".*sles.*12-4.*amd64.*hana.*" // retrievable from deprecated list
    # sles-12-5-sap-ha = ".*sles.*12-5.*amd64.*hana.*" // retrievable from deprecated list
    # sles-15-1-sap-ha = ".*sles.*15-1.*amd64.*hana.*" // retrievable from deprecated list
    sles-15-2-sap-ha = ".*sles.*15-2.*amd64.*hana.*"
    sles-15-3-sap-ha = ".*sles.*15-3.*amd64.*hana.*"
    sles-15-4-sap-ha = ".*sles.*15-4.*amd64.*hana.*"
    sles-15-5-sap-ha = ".*sles.*15-5.*amd64.*hana.*"
    sles-15-6-sap-ha = ".*sles.*15-6.*amd64.*hana.*"

  }

}
