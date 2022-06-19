locals {

  aws_vpc_subnet_create_boolean = var.aws_vpc_subnet_id == "new" ? true : false

  # Directories start with "C:..." on Windows; All other OSs use "/" for root.
  detect_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
  detect_shell = substr(pathexpand("~"), 0, 1) == "/" ? true : false

}
