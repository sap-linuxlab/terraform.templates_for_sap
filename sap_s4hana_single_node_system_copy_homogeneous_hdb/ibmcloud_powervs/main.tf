
module "run_account_init_module" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/account_init"

  module_var_resource_group_name           = local.resource_group_create_boolean ? 0 : var.ibmcloud_resource_group
  module_var_resource_group_create_boolean = local.resource_group_create_boolean

  module_var_resource_prefix = var.resource_prefix

  module_var_ibmcloud_region = local.ibmcloud_region

  module_var_ibmcloud_vpc_subnet_name           = local.ibmcloud_vpc_subnet_create_boolean ? 0 : var.ibmcloud_vpc_subnet_name
  module_var_ibmcloud_vpc_subnet_create_boolean = local.ibmcloud_vpc_subnet_create_boolean
  module_var_ibmcloud_vpc_availability_zone     = var.map_ibm_powervs_to_vpc_az[var.ibmcloud_powervs_location]

  module_var_ibmcloud_api_key = var.ibmcloud_api_key

}


module "run_account_bootstrap_module" {

  depends_on = [
    module.run_account_init_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/account_bootstrap"

  module_var_resource_group_id = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix   = var.resource_prefix

  module_var_ibmcloud_region = local.ibmcloud_region

  module_var_ibmcloud_vpc_subnet_name           = local.ibmcloud_vpc_subnet_create_boolean ? module.run_account_init_module.output_vpc_subnet_name : var.ibmcloud_vpc_subnet_name
  module_var_ibmcloud_vpc_subnet_create_boolean = local.ibmcloud_vpc_subnet_create_boolean
  module_var_ibmcloud_vpc_availability_zone     = var.map_ibm_powervs_to_vpc_az[var.ibmcloud_powervs_location]

  module_var_dns_root_domain_name = var.dns_root_domain

}


module "run_account_iam_module" {

  depends_on = [
    module.run_account_bootstrap_module
  ]

  count = var.ibmcloud_iam_yesno == "yes" ? 1 : 0

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/account_iam"

  module_var_resource_group_id = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix   = var.resource_prefix

}


module "run_bastion_inject_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/bastion_inject"

  module_var_resource_group_id = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix   = var.resource_prefix
  module_var_resource_tags     = var.resource_tags

  module_var_ibmcloud_region = local.ibmcloud_region

  module_var_ibmcloud_vpc_subnet_name = local.ibmcloud_vpc_subnet_create_boolean ? module.run_account_init_module.output_vpc_subnet_name : var.ibmcloud_vpc_subnet_name

  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_ssh_key_id      = module.run_account_bootstrap_module.output_bastion_ssh_key_id
  module_var_bastion_public_ssh_key  = module.run_account_bootstrap_module.output_bastion_public_ssh_key
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

  module_var_bastion_os_image = var.map_os_image_regex[var.bastion_os_image]

}


module "run_powervs_account_bootstrap_module" {

  depends_on = [
    module.run_account_bootstrap_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_powervs/account_bootstrap_addon"

  module_var_resource_group_id        = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix          = var.resource_prefix
  module_var_ibmcloud_power_zone      = lower(var.ibmcloud_powervs_location)
  module_var_ibmcloud_vpc_subnet_name = local.ibmcloud_vpc_subnet_create_boolean ? module.run_account_init_module.output_vpc_subnet_name : var.ibmcloud_vpc_subnet_name

}


module "run_powervs_interconnect_sg_update_module" {

  depends_on = [
    module.run_bastion_inject_module,
    module.run_powervs_account_bootstrap_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/powervs_interconnect_sg_update"

  module_var_bastion_security_group_id = module.run_bastion_inject_module.output_bastion_security_group_id
  module_var_host_security_group_id    = module.run_account_bootstrap_module.output_host_security_group_id

  module_var_power_group_network_private_subnet = module.run_powervs_account_bootstrap_module.output_power_group_network_private_subnet

}


module "run_powervs_interconnect_proxy_provision_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module,
    module.run_powervs_interconnect_sg_update_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/powervs_interconnect_proxy_provision"

  # Set Terraform Module Variables using Terraform Variables at runtime

  module_var_resource_group_id = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix   = var.resource_prefix
  module_var_resource_tags     = var.resource_tags

  module_var_ibmcloud_vpc_subnet_name = local.ibmcloud_vpc_subnet_create_boolean ? module.run_account_init_module.output_vpc_subnet_name : var.ibmcloud_vpc_subnet_name

  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_public_ssh_key  = module.run_account_bootstrap_module.output_bastion_public_ssh_key
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

  module_var_bastion_floating_ip                  = module.run_bastion_inject_module.output_bastion_ip
  module_var_bastion_connection_security_group_id = module.run_bastion_inject_module.output_bastion_connection_security_group_id

  module_var_host_ssh_key_id        = module.run_account_bootstrap_module.output_host_ssh_key_id
  module_var_host_private_ssh_key   = module.run_account_bootstrap_module.output_host_private_ssh_key
  module_var_host_security_group_id = module.run_account_bootstrap_module.output_host_security_group_id

  module_var_proxy_os_image = var.map_os_image_regex[var.bastion_os_image]

  module_var_dns_root_domain_name  = var.dns_root_domain
  module_var_dns_services_instance = module.run_account_bootstrap_module.output_host_dns_services_instance

  module_var_virtual_server_hostname = "${var.resource_prefix}-powervs-proxy"

  module_var_virtual_server_profile = "cx2-4x8"

}


module "run_powervs_host_provision_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module,
    module.run_powervs_interconnect_sg_update_module,
    module.run_powervs_interconnect_proxy_provision_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_powervs/host_provision"

  module_var_resource_group_id = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix   = var.resource_prefix
  module_var_resource_tags     = var.resource_tags

  module_var_ibm_power_group_guid = module.run_powervs_account_bootstrap_module.output_power_group_guid
  module_var_power_group_networks = module.run_powervs_account_bootstrap_module.output_power_group_networks

  module_var_ibmcloud_vpc_subnet_name = local.ibmcloud_vpc_subnet_create_boolean ? module.run_account_init_module.output_vpc_subnet_name : var.ibmcloud_vpc_subnet_name

  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key
  module_var_bastion_ip              = module.run_bastion_inject_module.output_bastion_ip

  module_var_host_public_ssh_key  = module.run_account_bootstrap_module.output_host_public_ssh_key
  module_var_host_private_ssh_key = module.run_account_bootstrap_module.output_host_private_ssh_key

  module_var_host_os_image = var.map_os_image_regex[var.host_os_image]

  module_var_dns_root_domain_name  = var.dns_root_domain
  module_var_dns_services_instance = module.run_account_bootstrap_module.output_host_dns_services_instance

  module_var_dns_proxy_ip        = module.run_powervs_interconnect_proxy_provision_module.output_proxy_private_ip
  module_var_web_proxy_url       = "http://${module.run_powervs_interconnect_proxy_provision_module.output_proxy_private_ip}:${module.run_powervs_interconnect_proxy_provision_module.output_proxy_port_squid}"
  module_var_web_proxy_exclusion = "localhost,127.0.0.1,${var.dns_root_domain}" // Web Proxy exclusion list for hosts running on IBM Power (e.g. localhost,127.0.0.1,custom.root.domain)

  module_var_os_vendor_account_user          = var.os_vendor_account_user
  module_var_os_vendor_account_user_passcode = var.os_vendor_account_user_passcode

  # Set Terraform Module Variables using for_each loop on a map Terraform Variable with nested objects

  for_each = toset([
    for key, value in var.map_host_specifications[var.host_specification_plan] : key
  ])

  module_var_virtual_server_hostname = each.key

  module_var_virtual_server_profile = var.map_host_specifications[var.host_specification_plan][each.key].virtual_server_profile

  module_var_disk_volume_type_hana_data     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_data
  module_var_disk_volume_count_hana_data    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data
  module_var_disk_volume_capacity_hana_data = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_data

  module_var_lvm_enable_hana_data                               = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data
  module_var_lvm_pv_data_alignment_hana_data                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_data : 0
  module_var_lvm_vg_data_alignment_hana_data                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_data : 0
  module_var_lvm_vg_physical_extent_size_hana_data              = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_data : 0
  module_var_lvm_lv_stripe_size_hana_data                       = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_data : 0
  module_var_filesystem_hana_data                               = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_data
  module_var_physical_partition_filesystem_block_size_hana_data = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_data

  module_var_disk_volume_type_hana_log     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_log
  module_var_disk_volume_count_hana_log    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log
  module_var_disk_volume_capacity_hana_log = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_log

  module_var_lvm_enable_hana_log                               = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log
  module_var_lvm_pv_data_alignment_hana_log                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_log : 0
  module_var_lvm_vg_data_alignment_hana_log                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_log : 0
  module_var_lvm_vg_physical_extent_size_hana_log              = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_log : 0
  module_var_lvm_lv_stripe_size_hana_log                       = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_log : 0
  module_var_filesystem_hana_log                               = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_log
  module_var_physical_partition_filesystem_block_size_hana_log = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_log

  module_var_disk_volume_type_hana_shared     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_shared
  module_var_disk_volume_count_hana_shared    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared
  module_var_disk_volume_capacity_hana_shared = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_shared

  module_var_lvm_enable_hana_shared                               = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared
  module_var_lvm_pv_data_alignment_hana_shared                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_shared : 0
  module_var_lvm_vg_data_alignment_hana_shared                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_shared : 0
  module_var_lvm_vg_physical_extent_size_hana_shared              = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_shared : 0
  module_var_lvm_lv_stripe_size_hana_shared                       = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_shared : 0
  module_var_filesystem_hana_shared                               = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_shared
  module_var_physical_partition_filesystem_block_size_hana_shared = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_shared

  module_var_disk_volume_count_usr_sap    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_usr_sap
  module_var_disk_volume_type_usr_sap     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_usr_sap
  module_var_disk_volume_capacity_usr_sap = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_usr_sap
  module_var_filesystem_usr_sap           = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_usr_sap

  module_var_disk_volume_count_sapmnt    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_sapmnt
  module_var_disk_volume_type_sapmnt     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_sapmnt
  module_var_disk_volume_capacity_sapmnt = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_sapmnt
  module_var_filesystem_sapmnt           = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_sapmnt

  module_var_disk_swapfile_size_gb     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_swapfile_size_gb
  module_var_disk_volume_count_swap    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap
  module_var_disk_volume_type_swap     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_swap : 0
  module_var_disk_volume_capacity_swap = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_swap : 0
  module_var_filesystem_swap           = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].filesystem_swap : 0

  module_var_disk_volume_capacity_software   = var.disk_volume_capacity_software
  module_var_disk_volume_type_software       = var.disk_volume_type_software
  module_var_sap_software_download_directory = var.sap_software_download_directory

}


module "run_shell_download_obj_store_ibmcos" {

  depends_on = [module.run_powervs_host_provision_module]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/shell_download_obj_store_ibmcos"

  # Terraform Module Variables using the prior Terraform Module Variables (from bootstrap module)
  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_public_ssh_key  = module.run_account_bootstrap_module.output_bastion_public_ssh_key
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

  module_var_bastion_floating_ip = module.run_bastion_inject_module.output_bastion_ip

  module_var_host_ssh_key_id      = module.run_account_bootstrap_module.output_host_ssh_key_id
  module_var_host_private_ssh_key = module.run_account_bootstrap_module.output_host_private_ssh_key


  # Set Terraform Module Variables using for_each loop on a map Terraform Variable at runtime

  for_each                   = module.run_powervs_host_provision_module
  module_var_host_private_ip = join(", ", each.value.*.output_host_private_ip)

  module_var_ibmcloud_api_key          = var.ibmcloud_api_key
  module_var_ibmcos_bucket             = var.ibmcos_bucket
  module_var_ibmcos_download_directory = var.sap_hana_backup_directory

}


module "run_ansible_sap_s4hana_system_copy_hdb" {

  depends_on = [
    module.run_powervs_host_provision_module,
    module.run_shell_download_obj_store_ibmcos
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_s4hana_system_copy_hdb"

  # Terraform Module Variables using the prior Terraform Module Variables (from bootstrap module)
  module_var_bastion_boolean         = true // required as true boolean for any Cloud Service Provider (CSP)
  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_public_ssh_key  = module.run_account_bootstrap_module.output_bastion_public_ssh_key
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

  module_var_bastion_floating_ip = module.run_bastion_inject_module.output_bastion_ip

  module_var_host_private_ssh_key = module.run_account_bootstrap_module.output_host_private_ssh_key


  # Set Terraform Module Variables using for_each loop on a map Terraform Variable at runtime

  for_each                        = module.run_powervs_host_provision_module
  module_var_host_private_ip      = join(", ", each.value.*.output_host_private_ip)
  module_var_hostname             = join(", ", each.value.*.output_host_name)
  module_var_dns_root_domain_name = var.dns_root_domain

  module_var_sap_id_user          = var.sap_id_user
  module_var_sap_id_user_password = var.sap_id_user_password

  module_var_sap_hana_install_master_password = var.sap_hana_install_master_password
  module_var_sap_hana_install_sid             = var.sap_hana_install_sid
  module_var_sap_hana_install_instance_number = var.sap_hana_install_instance_number

  module_var_sap_swpm_sid = var.sap_s4hana_install_sid

  module_var_sap_hana_backup_directory        = var.sap_hana_backup_directory
  module_var_sap_hana_backup_filename_prefix  = var.sap_hana_backup_filename_prefix
  module_var_sap_swpm_backup_system_password  = var.sap_swpm_backup_system_password
  module_var_sap_swpm_db_schema_abap          = var.sap_hana_backup_db_schema_to_swpm
  module_var_sap_swpm_db_schema_abap_password = var.sap_swpm_db_schema_abap_password
  module_var_sap_swpm_ddic_000_password       = var.sap_swpm_ddic_000_password

  module_var_sap_swpm_template_selected = var.sap_swpm_template_selected

}
