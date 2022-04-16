locals {

  resource_group_create_boolean = var.ibmcloud_resource_group == "new" ? true : false

  ibmcloud_vpc_subnet_create_boolean = var.ibmcloud_vpc_subnet_name == "new" ? true : false

  ibmcloud_vpc_subnet_name_entry_is_ip = (
    can(
      regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)([/][0-3][0-2]?|[/][1-2][0-9]|[/][0-9])$",
        var.ibmcloud_vpc_subnet_name
      )
  ) ? true : false)

  ibmcloud_vpc_availability_zone = "${var.ibmcloud_region}-1"

}
