
variable "map_os_image_regex" {

  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"

  type = map(any)

  default = {

    rhel-7-6-sap-hana = ".*redhat.*7-6.*amd64.*hana.*"

    rhel-8-1-sap-hana = ".*redhat.*8-1.*amd64.*hana.*"

    rhel-8-2-sap-hana = ".*redhat.*8-2.*amd64.*hana.*"

    rhel-8-4-sap-hana = ".*redhat.*8-4.*amd64.*hana.*"

    rhel-7-6-sap-applications = ".*redhat.*7-6.*amd64.*applications.*"

    rhel-8-1-sap-applications = ".*redhat.*8-1.*amd64.*applications.*"

    rhel-8-2-sap-applications = ".*redhat.*8-2.*amd64.*applications.*"

    rhel-8-4-sap-applications = ".*redhat.*8-4.*amd64.*applications.*"

    rhel-8-4 = ".*redhat.*8-4.*minimal.*amd64.*"

    sles-12-4-sap-hana = ".*sles.*12-4.*amd64.*hana.*"

    sles-15-1-sap-hana = ".*sles.*15-1.*amd64.*hana.*"

    sles-15-2-sap-hana = ".*sles.*15-2.*amd64.*hana.*"

    sles-12-4-sap-applications = ".*sles.*12-4.*amd64.*applications.*"

    sles-15-1-sap-applications = ".*sles.*15-1.*amd64.*applications.*"

    sles-15-2-sap-applications = ".*sles.*15-2.*amd64.*applications.*"

  }

}
