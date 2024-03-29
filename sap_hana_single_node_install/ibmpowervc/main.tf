
module "run_ansible_dry_run" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_hana_install?ref=main"

  module_var_dry_run_test = "ppc64le" // x86_64 or ppc64le

  # Terraform Module Variables which are mandatory, all with an empty string
  module_var_bastion_boolean                  = false
  module_var_bastion_user                     = ""
  module_var_bastion_ssh_port                 = 0
  module_var_bastion_private_ssh_key          = ""
  module_var_bastion_floating_ip              = ""
  module_var_host_private_ssh_key             = ""
  module_var_host_private_ip                  = ""
  module_var_hostname                         = "software_media_dry_run"
  module_var_sap_id_user                      = var.sap_id_user
  module_var_sap_id_user_password             = var.sap_id_user_password
  module_var_sap_hana_install_master_password = ""
  module_var_sap_hana_install_sid             = ""
  module_var_sap_hana_install_instance_number = ""

}


module "run_host_bootstrap_module" {

  depends_on = [
    module.run_ansible_dry_run
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmpowervc/host_bootstrap?ref=main"

  # Set Terraform Module Variables using Terraform Variables at runtime
  module_var_resource_prefix = var.resource_prefix

}


module "run_host_provision_module" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmpowervc/host_provision?ref=main"

  # Set Terraform Module Variables using Terraform Variables at runtime

  module_var_ibmpowervc_template_compute_name                = local.ibmpowervc_template_compute_name_create_boolean ? 0 : var.ibmpowervc_template_compute_name
  module_var_ibmpowervc_template_compute_name_create_boolean = local.ibmpowervc_template_compute_name_create_boolean

  module_var_resource_prefix = var.resource_prefix

  module_var_host_ssh_key_name    = module.run_host_bootstrap_module.output_host_ssh_key_name
  module_var_host_public_ssh_key  = module.run_host_bootstrap_module.output_host_public_ssh_key
  module_var_host_private_ssh_key = module.run_host_bootstrap_module.output_host_private_ssh_key

  module_var_ibmpowervc_host_group_name = var.ibmpowervc_host_group_name
  module_var_ibmpowervc_network_name    = var.ibmpowervc_network_name

  module_var_ibmpowervc_compute_cpu_threads = var.map_host_specifications[var.host_specification_plan][each.key].ibmpowervc_compute_cpu_threads
  module_var_ibmpowervc_compute_ram_gb      = var.map_host_specifications[var.host_specification_plan][each.key].ibmpowervc_compute_ram_gb

  module_var_ibmpowervc_os_image_name = var.ibmpowervc_os_image_name

  module_var_dns_root_domain_name = var.dns_root_domain

  module_var_web_proxy_url       = var.web_proxy_url
  module_var_web_proxy_exclusion = "localhost,127.0.0.1,${var.dns_root_domain}" // Web Proxy exclusion list for hosts running on IBM Power (e.g. localhost,127.0.0.1,custom.root.domain)

  module_var_os_vendor_account_user          = var.os_vendor_account_user
  module_var_os_vendor_account_user_passcode = var.os_vendor_account_user_passcode
  module_var_os_systems_mgmt_host            = var.os_systems_mgmt_host

  # Set Terraform Module Variables using for_each loop on a map Terraform Variable with nested objects

  for_each = toset([
    for key, value in var.map_host_specifications[var.host_specification_plan] : key
  ])

  module_var_lpar_hostname = each.key

  module_var_ibmpowervc_storage_storwize_hostname_short     = var.ibmpowervc_storage_storwize_hostname_short
  module_var_ibmpowervc_storage_storwize_storage_pool       = var.ibmpowervc_storage_storwize_storage_pool
  module_var_ibmpowervc_storage_storwize_storage_pool_flash = var.ibmpowervc_storage_storwize_storage_pool_flash

  module_var_storage_definition = [ for storage_item in var.map_host_specifications[var.host_specification_plan][each.key]["storage_definition"] : storage_item if contains(keys(storage_item),"disk_size") && try(storage_item.swap_path,"") == "" ]


}


module "run_ansible_sap_hana_install" {

  depends_on = [
    module.run_host_provision_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_hana_install?ref=main"


  # Terraform Module Variables using the prior Terraform Module Variables (from bootstrap module)
  module_var_bastion_boolean         = var.bastion_boolean
  module_var_bastion_user            = var.bastion_boolean ? var.bastion_user : ""
  module_var_bastion_ssh_port        = var.bastion_boolean ? var.bastion_ssh_port : 0
  module_var_bastion_private_ssh_key = var.bastion_boolean ? var.bastion_private_ssh_key : 0
  module_var_bastion_floating_ip     = var.bastion_boolean ? var.bastion_ip : 0

  module_var_host_private_ssh_key = module.run_host_bootstrap_module.output_host_private_ssh_key


  # Set Terraform Module Variables using for_each loop on a map Terraform Variable at runtime

  for_each                   = module.run_host_provision_module
  module_var_host_private_ip = join(", ", each.value.*.output_host_private_ip)
  module_var_hostname        = join(", ", each.value.*.output_host_name)

  module_var_sap_id_user          = var.sap_id_user
  module_var_sap_id_user_password = var.sap_id_user_password

  module_var_sap_hana_install_master_password = var.sap_hana_install_master_password
  module_var_sap_hana_install_sid             = var.sap_hana_install_sid
  module_var_sap_hana_install_instance_number = var.sap_hana_install_instance_number

  module_var_terraform_host_specification_storage_definition = var.map_host_specifications[var.host_specification_plan][join(", ", each.value.*.output_host_name)]["storage_definition"]

}
