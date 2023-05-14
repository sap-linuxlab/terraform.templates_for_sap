
module "run_ansible_dry_run" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_solman_sapase_install?ref=dev"

  module_var_dry_run_test = "x86_64" // x86_64 or ppc64le

  # Terraform Module Variables which are mandatory, all with an empty string
  module_var_bastion_boolean                  = false
  module_var_bastion_user                     = ""
  module_var_bastion_ssh_port                 = 0
  module_var_bastion_private_ssh_key          = ""
  module_var_bastion_floating_ip              = ""
  module_var_host_private_ssh_key             = ""
  module_var_host_private_ip                  = ""
  module_var_hostname                         = "software_media_dry_run"
  module_var_dns_root_domain_name             = ""
  module_var_sap_id_user                      = var.sap_id_user
  module_var_sap_id_user_password             = var.sap_id_user_password
  module_var_sap_swpm_sid                     = ""
  module_var_sap_swpm_db_schema_abap          = ""
  module_var_sap_swpm_db_schema_abap_password = ""
  module_var_sap_swpm_ddic_000_password       = ""
  module_var_sap_swpm_template_selected       = "sap_solman_72_sr2_sapase_onehost"
}


module "run_account_init_module" {

  depends_on = [
    module.run_ansible_dry_run
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//msazure_vm/account_init?ref=main"

  module_var_az_resource_group_name           = local.resource_group_create_boolean ? 0 : var.az_resource_group_name
  module_var_az_resource_group_create_boolean = local.resource_group_create_boolean

  module_var_resource_prefix = var.resource_prefix

  module_var_az_location_region               = var.az_location_region
  module_var_az_location_availability_zone_no = var.az_location_availability_zone_no

  module_var_az_vnet_name                = local.az_vnet_name_create_boolean ? 0 : var.az_vnet_name
  module_var_az_vnet_name_create_boolean = local.az_vnet_name_create_boolean

  module_var_az_vnet_subnet_name                = local.az_vnet_subnet_name_create_boolean ? 0 : var.az_vnet_subnet_name
  module_var_az_vnet_subnet_name_create_boolean = local.az_vnet_subnet_name_create_boolean

}


module "run_account_bootstrap_module" {

  depends_on = [
    module.run_account_init_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//msazure_vm/account_bootstrap?ref=main"

  module_var_az_resource_group_name = module.run_account_init_module.output_resource_group_name
  module_var_resource_prefix        = var.resource_prefix

  module_var_az_location_region               = var.az_location_region
  module_var_az_location_availability_zone_no = var.az_location_availability_zone_no

  module_var_az_vnet_name        = module.run_account_init_module.output_vnet_name
  module_var_az_vnet_subnet_name = module.run_account_init_module.output_vnet_subnet_name

  module_var_dns_root_domain_name = var.dns_root_domain
}


#module "run_account_iam_module" {
#
#  depends_on = [
#    module.run_account_bootstrap_module
#  ]
#
#  count = var.az_iam_yesno == "yes" ? 1 : 0
#
#  source = "github.com/sap-linuxlab/terraform.modules_for_sap//msazure_vm/account_iam?ref=main"
#
#  module_var_az_resource_group_name = module.run_account_init_module.output_resource_group_name
#  module_var_resource_prefix = var.resource_prefix
#
#}


module "run_bastion_inject_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//msazure_vm/bastion_inject?ref=main"

  module_var_az_resource_group_name = module.run_account_init_module.output_resource_group_name
  module_var_resource_prefix        = var.resource_prefix

  module_var_az_location_region               = var.az_location_region
  module_var_az_location_availability_zone_no = var.az_location_availability_zone_no

  module_var_az_vnet_name        = module.run_account_init_module.output_vnet_name
  module_var_az_vnet_subnet_name = module.run_account_init_module.output_vnet_subnet_name

  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_ssh_key_id      = module.run_account_bootstrap_module.output_bastion_ssh_key_id
  module_var_bastion_public_ssh_key  = module.run_account_bootstrap_module.output_bastion_public_ssh_key
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

  module_var_bastion_os_image = var.map_os_image_regex[var.bastion_os_image]

}


module "run_host_network_access_sap_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//msazure_vm/host_network_access_sap?ref=main"

  module_var_az_resource_group_name = module.run_account_init_module.output_resource_group_name

  module_var_az_vnet_name        = module.run_account_init_module.output_vnet_name
  module_var_az_vnet_subnet_name = module.run_account_init_module.output_vnet_subnet_name

  module_var_host_security_group_name = module.run_account_bootstrap_module.output_host_security_group_name

  module_var_sap_nwas_abap_pas_instance_no = ""
  module_var_sap_nwas_java_ci_instance_no = var.sap_nwas_java_ci_instance_no
  module_var_sap_hana_instance_no     = ""

}


module "run_host_network_access_sap_public_via_proxy_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//msazure_vm/host_network_access_sap_public_via_proxy?ref=main"

  module_var_az_resource_group_name = module.run_account_init_module.output_resource_group_name

  module_var_az_vnet_name        = module.run_account_init_module.output_vnet_name
  module_var_az_vnet_subnet_name = module.run_account_init_module.output_vnet_subnet_name
  module_var_az_vnet_bastion_subnet_name = module.run_bastion_inject_module.output_vnet_bastion_subnet_name

  module_var_host_security_group_name               = module.run_account_bootstrap_module.output_host_security_group_name
  module_var_bastion_security_group_name            = module.run_bastion_inject_module.output_bastion_security_group_name
  module_var_bastion_connection_security_group_name = module.run_bastion_inject_module.output_bastion_connection_security_group_name

  module_var_sap_nwas_abap_pas_instance_no = ""
  module_var_sap_nwas_java_ci_instance_no = var.sap_nwas_java_ci_instance_no
  module_var_sap_hana_instance_no     = ""

}


module "run_host_provision_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//msazure_vm/host_provision?ref=main"


  module_var_az_resource_group_name = module.run_account_init_module.output_resource_group_name
  module_var_resource_prefix        = var.resource_prefix

  module_var_az_location_region               = var.az_location_region
  module_var_az_location_availability_zone_no = var.az_location_availability_zone_no

  module_var_az_vnet_name        = module.run_account_init_module.output_vnet_name
  module_var_az_vnet_subnet_name = module.run_account_init_module.output_vnet_subnet_name

  module_var_bastion_user             = var.bastion_user
  module_var_bastion_ssh_port         = var.bastion_ssh_port
  module_var_bastion_private_ssh_key  = module.run_account_bootstrap_module.output_bastion_private_ssh_key
  module_var_bastion_ip               = module.run_bastion_inject_module.output_bastion_ip
  module_var_bastion_connection_sg_id = module.run_bastion_inject_module.output_bastion_connection_security_group_id

  module_var_host_ssh_key_id      = module.run_account_bootstrap_module.output_host_ssh_key_id
  module_var_host_ssh_public_key  = module.run_account_bootstrap_module.output_host_public_ssh_key
  module_var_host_ssh_private_key = module.run_account_bootstrap_module.output_host_private_ssh_key
  module_var_host_sg_id           = module.run_account_bootstrap_module.output_host_security_group_id

  module_var_host_os_image = var.map_os_image_regex[var.host_os_image]

  module_var_dns_zone_name        = module.run_account_bootstrap_module.output_dns_zone_name
  module_var_dns_root_domain_name = var.dns_root_domain


  # Set Terraform Module Variables using for_each loop on a map Terraform Variable with nested objects

  for_each = toset([
    for key, value in var.map_host_specifications[var.host_specification_plan] : key
  ])

  module_var_host_name = each.key

  module_var_az_vm_instance = var.map_host_specifications[var.host_specification_plan][each.key].vm_instance

  module_var_disk_volume_count_hana_data                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data
  module_var_disk_volume_type_hana_data                           = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_data
  module_var_disk_volume_capacity_hana_data                       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_data
  module_var_disk_volume_iops_hana_data                           = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_data == "custom" ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_iops_hana_data : null
  module_var_lvm_enable_hana_data                                 = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? false : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data
  module_var_lvm_pv_data_alignment_hana_data                      = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_data : 0
  module_var_lvm_vg_data_alignment_hana_data                      = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_data : 0
  module_var_lvm_vg_physical_extent_size_hana_data                = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_data : 0
  module_var_lvm_lv_stripe_size_hana_data                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_data : 0
  module_var_filesystem_hana_data                                 = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_data
  module_var_physical_partition_filesystem_block_size_hana_data   = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_data

  module_var_disk_volume_count_hana_log                           = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log
  module_var_disk_volume_type_hana_log                            = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_log
  module_var_disk_volume_capacity_hana_log                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_log
  module_var_disk_volume_iops_hana_log                            = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_log == "custom" ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_iops_hana_log : null
  module_var_lvm_enable_hana_log                                  = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? false : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log
  module_var_lvm_pv_data_alignment_hana_log                       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_log : 0
  module_var_lvm_vg_data_alignment_hana_log                       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_log : 0
  module_var_lvm_vg_physical_extent_size_hana_log                 = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_log : 0
  module_var_lvm_lv_stripe_size_hana_log                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_log : 0
  module_var_filesystem_hana_log                                  = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_log
  module_var_physical_partition_filesystem_block_size_hana_log    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_log

  module_var_disk_volume_count_hana_shared                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared
  module_var_disk_volume_type_hana_shared                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_shared
  module_var_disk_volume_capacity_hana_shared                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_shared
  module_var_disk_volume_iops_hana_shared                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_shared == "custom" ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_iops_hana_shared : null
  module_var_lvm_enable_hana_shared                               = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? false : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared
  module_var_lvm_pv_data_alignment_hana_shared                    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_shared : 0
  module_var_lvm_vg_data_alignment_hana_shared                    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_shared : 0
  module_var_lvm_vg_physical_extent_size_hana_shared              = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_shared : 0
  module_var_lvm_lv_stripe_size_hana_shared                       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_shared : 0
  module_var_filesystem_hana_shared                               = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_shared
  module_var_physical_partition_filesystem_block_size_hana_shared = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_shared

  module_var_disk_volume_count_anydb                              = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb
  module_var_disk_volume_type_anydb                               = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_anydb
  module_var_disk_volume_capacity_anydb                           = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_anydb
  module_var_disk_volume_iops_anydb                               = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_anydb == "custom" ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_iops_anydb : null
  module_var_lvm_enable_anydb                                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? false : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb
  module_var_lvm_pv_data_alignment_anydb                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_anydb : 0
  module_var_lvm_vg_data_alignment_anydb                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_anydb : 0
  module_var_lvm_vg_physical_extent_size_anydb                    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_anydb : 0
  module_var_lvm_lv_stripe_size_anydb                             = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_anydb : 0
  module_var_filesystem_mount_path_anydb                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_mount_path_anydb
  module_var_filesystem_anydb                                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_anydb
  module_var_physical_partition_filesystem_block_size_anydb       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_anydb

  module_var_disk_volume_count_usr_sap    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_usr_sap
  module_var_disk_volume_type_usr_sap     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_usr_sap
  module_var_disk_volume_capacity_usr_sap = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_usr_sap
  module_var_filesystem_usr_sap           = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_usr_sap

  module_var_disk_volume_count_sapmnt    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_sapmnt
  module_var_disk_volume_type_sapmnt     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_sapmnt
  module_var_disk_volume_capacity_sapmnt = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_sapmnt
  module_var_filesystem_sapmnt           = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_sapmnt
  module_var_nfs_boolean_sapmnt          = false // always false, single node installation
  module_var_nfs_fqdn_sapmnt             = "" // always false, single node installation

  module_var_disk_swapfile_size_gb     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_swapfile_size_gb
  module_var_disk_volume_count_swap    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap
  module_var_disk_volume_type_swap     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_swap : 0
  module_var_disk_volume_capacity_swap = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_swap : 0
  module_var_filesystem_swap           = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].filesystem_swap : 0

  module_var_disk_volume_capacity_software   = var.disk_volume_capacity_software
  module_var_sap_software_download_directory = var.sap_software_download_directory

}


module "run_ansible_sap_solman_java_sapase_install" {

  depends_on = [module.run_host_provision_module]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_solman_sapase_install?ref=dev"


  # Terraform Module Variables using the prior Terraform Module Variables (from bootstrap module)
  module_var_bastion_boolean         = true // required as true boolean for any Cloud Service Provider (CSP)
  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

  module_var_bastion_floating_ip     = module.run_bastion_inject_module.output_bastion_ip

  module_var_host_private_ssh_key    = module.run_account_bootstrap_module.output_host_private_ssh_key


  # Set Terraform Module Variables using for_each loop on a map Terraform Variable at runtime

  for_each                           = module.run_host_provision_module
  module_var_host_private_ip         = join(", ", each.value.*.output_host_private_ip)
  module_var_hostname                = join(", ", each.value.*.output_host_name)
  module_var_dns_root_domain_name    = var.dns_root_domain

  module_var_sap_id_user                      = var.sap_id_user
  module_var_sap_id_user_password             = var.sap_id_user_password

  module_var_sap_anydb_install_sid             = var.sap_anydb_install_sid
  module_var_sap_anydb_install_instance_number = var.sap_anydb_install_instance_number

  module_var_sap_swpm_sid                     = var.sap_nwas_install_sid

  module_var_sap_swpm_db_schema_abap          = "SAPJAVA1"
  module_var_sap_swpm_db_schema_abap_password = var.sap_anydb_install_master_password
  module_var_sap_swpm_db_system_password      = var.sap_anydb_install_master_password
  module_var_sap_swpm_db_systemdb_password    = var.sap_anydb_install_master_password
  module_var_sap_swpm_db_sidadm_password      = var.sap_anydb_install_master_password
  module_var_sap_swpm_ddic_000_password       = var.sap_anydb_install_master_password

  module_var_sap_swpm_ascs_instance_nr        = var.sap_nwas_abap_ascs_instance_no
  module_var_sap_swpm_pas_instance_nr         = var.sap_nwas_abap_pas_instance_no

  module_var_sap_swpm_nwas_java_instance_nr   = var.sap_nwas_java_ci_instance_no

  module_var_sap_swpm_master_password         = var.sap_anydb_install_master_password

  module_var_sap_swpm_template_selected       = "sap_solman_72_sr2_sapase_onehost"

  module_var_filesystem_mount_path_anydb      = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_mount_path_anydb

  module_var_sap_software_download_directory  = var.sap_software_download_directory

}
