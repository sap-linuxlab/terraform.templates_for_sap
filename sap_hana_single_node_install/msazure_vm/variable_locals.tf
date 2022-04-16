locals {

  resource_group_create_boolean = var.az_resource_group_name == "new" ? true : false

  az_vnet_name_create_boolean = var.az_vnet_name == "new" ? true : false

  az_vnet_subnet_name_create_boolean = var.az_vnet_subnet_name == "new" ? true : false

  az_availability_zone_no = 1

  az_availability_zone = "${var.az_region}-1"

}
