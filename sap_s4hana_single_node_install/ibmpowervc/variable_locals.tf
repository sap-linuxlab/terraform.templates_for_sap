
locals {

  ibmpowervc_template_compute_name_create_boolean = var.ibmpowervc_template_compute_name == "new" ? true : false
  #ibmpowervc_template_storage_name_create_boolean = var.ibmpowervc_template_storage_name == "new" ? true : false

  # Directories start with "C:..." on Windows; All other OSs use "/" for root.
  detect_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
  detect_shell = substr(pathexpand("~"), 0, 1) == "/" ? true : false

}
