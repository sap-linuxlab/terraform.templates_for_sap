locals {

  aws_vpc_subnet_create_boolean = var.aws_vpc_subnet_id == "new" ? true : false

  # Directories start with "C:..." on Windows; All other OSs use "/" for root.
  detect_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
  detect_shell = substr(pathexpand("~"), 0, 1) == "/" ? true : false

  # Used for displaying Shell ssh connection output
  # /proc/version contains WSL subsstring, if detected then running Windows Subsystem for Linux
  not_wsl = fileexists("/proc/version") ? length(regexall("WSL", file("/proc/version"))) > 0 ? false : true : true

  # Used for displaying Windows PowerShell ssh connection output
  # /proc/version contains WSL subsstring, if detected then running Windows Subsystem for Linux
  is_wsl = fileexists("/proc/version") ? length(regexall("WSL", file("/proc/version"))) > 0 ? true : false : false

}
