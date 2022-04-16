
module "run_host_bootstrap_module" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmpowervc/host_bootstrap"

  # Set Terraform Module Variables using Terraform Variables at runtime
  module_var_resource_prefix = var.resource_prefix

}


module "run_host_provision_module" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmpowervc/host_provision"

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

  module_var_disk_volume_count_hana_data                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data
  module_var_disk_volume_capacity_hana_data                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_data
  module_var_lvm_enable_hana_data                               = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data
  module_var_lvm_pv_data_alignment_hana_data                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_data : 0
  module_var_lvm_vg_data_alignment_hana_data                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_data : 0
  module_var_lvm_vg_physical_extent_size_hana_data              = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_data : 0
  module_var_lvm_lv_stripe_size_hana_data                       = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_data : 0
  module_var_filesystem_hana_data                               = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_data
  module_var_physical_partition_filesystem_block_size_hana_data = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_data

  module_var_disk_volume_count_hana_log                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log
  module_var_disk_volume_capacity_hana_log                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_log
  module_var_lvm_enable_hana_log                               = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log
  module_var_lvm_pv_data_alignment_hana_log                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_log : 0
  module_var_lvm_vg_data_alignment_hana_log                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_log : 0
  module_var_lvm_vg_physical_extent_size_hana_log              = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_log : 0
  module_var_lvm_lv_stripe_size_hana_log                       = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_log : 0
  module_var_filesystem_hana_log                               = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_log
  module_var_physical_partition_filesystem_block_size_hana_log = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_log

  module_var_disk_volume_count_hana_shared                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared
  module_var_disk_volume_capacity_hana_shared                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_shared
  module_var_lvm_enable_hana_shared                               = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared
  module_var_lvm_pv_data_alignment_hana_shared                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_shared : 0
  module_var_lvm_vg_data_alignment_hana_shared                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_shared : 0
  module_var_lvm_vg_physical_extent_size_hana_shared              = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_shared : 0
  module_var_lvm_lv_stripe_size_hana_shared                       = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_shared : 0
  module_var_filesystem_hana_shared                               = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_shared
  module_var_physical_partition_filesystem_block_size_hana_shared = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_shared

  module_var_disk_volume_count_usr_sap    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_usr_sap
  module_var_disk_volume_capacity_usr_sap = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_usr_sap
  module_var_filesystem_usr_sap           = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_usr_sap

  module_var_disk_volume_count_sapmnt    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_sapmnt
  module_var_disk_volume_capacity_sapmnt = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_sapmnt
  module_var_filesystem_sapmnt           = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_sapmnt

  module_var_disk_swapfile_size_gb     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_swapfile_size_gb
  module_var_disk_volume_count_swap    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap
  module_var_disk_volume_capacity_swap = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_swap : 0
  module_var_filesystem_swap           = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].filesystem_swap : 0

  module_var_disk_volume_capacity_software   = var.disk_volume_capacity_software
  module_var_sap_software_download_directory = var.sap_software_download_directory

}


module "run_ansible_sap_hana_install" {

  depends_on = [
    module.run_host_provision_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_hana_install"


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

}
