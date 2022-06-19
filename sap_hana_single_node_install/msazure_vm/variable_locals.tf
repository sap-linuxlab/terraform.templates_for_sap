locals {

  resource_group_create_boolean = var.az_resource_group_name == "new" ? true : false

  az_vnet_name_create_boolean = var.az_vnet_name == "new" ? true : false

  az_vnet_subnet_name_create_boolean = var.az_vnet_subnet_name == "new" ? true : false

  az_availability_zone_no = 1

  az_availability_zone = "${var.az_region}-1"

  # Directories start with "C:..." on Windows; All other OSs use "/" for root.
  detect_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
  detect_shell = substr(pathexpand("~"), 0, 1) == "/" ? true : false

}
