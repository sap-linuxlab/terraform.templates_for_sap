
# Find latest OS Image for RHEL
# az account list-locations | jq .[].displayName
# az vm image list --all --publisher redhat --offer RHEL-SAP-APPS --sku 8 --query "[?starts_with(version,'8.4')]" | jq .[].version --raw-output | sort -r | head -1
# az vm image list --all --publisher redhat --offer RHEL-SAP-HA --sku 8 --query "[?starts_with(version,'8.4')]" | jq .[].version --raw-output | sort -r | head -1

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
    }

  }

}
