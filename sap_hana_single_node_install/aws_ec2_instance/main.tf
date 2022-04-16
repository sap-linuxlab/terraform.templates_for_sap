
module "run_account_init_module" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/account_init"

  module_var_resource_prefix = var.resource_prefix

  module_var_aws_vpc_subnet_id = var.aws_vpc_subnet_id

  module_var_aws_vpc_subnet_create_boolean = local.aws_vpc_subnet_create_boolean

}


module "run_account_bootstrap_module" {

  depends_on = [
    module.run_account_init_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/account_bootstrap"

  module_var_resource_prefix = var.resource_prefix

  module_var_aws_vpc_subnet_id = local.aws_vpc_subnet_create_boolean ? module.run_account_init_module.output_aws_vpc_subnet_id : var.aws_vpc_subnet_id

  module_var_dns_root_domain_name = var.dns_root_domain

}


#module "run_account_iam_module" {
#
#  depends_on = [
#    module.run_account_bootstrap_module
#  ]


module "run_bastion_inject_module" {

  depends_on = [
    module.run_account_bootstrap_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/bastion_inject"

  module_var_resource_prefix = var.resource_prefix

  module_var_aws_vpc_subnet_id = local.aws_vpc_subnet_create_boolean ? module.run_account_init_module.output_aws_vpc_subnet_id : var.aws_vpc_subnet_id
  module_var_aws_vpc_igw_id    = module.run_account_init_module.output_aws_vpc_igw_id

  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_os_image        = var.map_os_image_regex[var.bastion_os_image]
  module_var_bastion_ssh_key_name    = module.run_account_bootstrap_module.output_bastion_ssh_key_name
  module_var_bastion_public_ssh_key  = module.run_account_bootstrap_module.output_bastion_public_ssh_key
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

}


module "run_host_network_access_sap_module" {

  depends_on = [
    module.run_bastion_inject_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/host_network_access_sap"

  module_var_resource_prefix = var.resource_prefix

  module_var_aws_vpc_subnet_id = local.aws_vpc_subnet_create_boolean ? module.run_account_init_module.output_aws_vpc_subnet_id : var.aws_vpc_subnet_id

  module_var_sap_hana_instance_no = var.sap_hana_install_instance_number

}


module "run_host_provision_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/host_provision"

  # Set Terraform Module Variables using Terraform Variables at runtime

  module_var_aws_vpc_subnet_id = local.aws_vpc_subnet_create_boolean ? module.run_account_init_module.output_aws_vpc_subnet_id : var.aws_vpc_subnet_id

  module_var_bastion_user             = var.bastion_user
  module_var_bastion_ssh_port         = var.bastion_ssh_port
  module_var_bastion_private_ssh_key  = module.run_account_bootstrap_module.output_bastion_private_ssh_key
  module_var_bastion_ip               = module.run_bastion_inject_module.output_bastion_ip
  module_var_bastion_connection_sg_id = module.run_bastion_inject_module.output_bastion_connection_security_group_id

  module_var_host_ssh_key_name    = module.run_account_bootstrap_module.output_host_ssh_key_name
  module_var_host_ssh_public_key  = module.run_account_bootstrap_module.output_host_public_ssh_key
  module_var_host_ssh_private_key = module.run_account_bootstrap_module.output_host_private_ssh_key
  module_var_host_sg_id           = module.run_account_bootstrap_module.output_host_security_group_id

  module_var_host_os_image = var.map_os_image_regex[var.host_os_image]

  module_var_dns_zone_id          = module.run_account_bootstrap_module.output_dns_zone_id
  module_var_dns_root_domain_name = module.run_account_bootstrap_module.output_dns_domain_name
  module_var_dns_nameserver_list  = module.run_account_bootstrap_module.output_dns_nameserver_list


  # Set Terraform Module Variables using for_each loop on a map Terraform Variable with nested objects

  for_each = toset([
    for key, value in var.map_host_specifications[var.host_specification_plan] : key
  ])

  module_var_host_name = each.key

  module_var_aws_ec2_instance_type = var.map_host_specifications[var.host_specification_plan][each.key].ec2_instance_type

  module_var_disk_volume_type_hana_data                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_data
  module_var_disk_volume_count_hana_data                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data
  module_var_disk_volume_capacity_hana_data                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_data
  module_var_disk_volume_iops_hana_data                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_data == "custom" ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_iops_hana_data : null
  module_var_lvm_enable_hana_data                               = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data
  module_var_lvm_pv_data_alignment_hana_data                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_data : 0
  module_var_lvm_vg_data_alignment_hana_data                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_data : 0
  module_var_lvm_vg_physical_extent_size_hana_data              = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_data : 0
  module_var_lvm_lv_stripe_size_hana_data                       = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_data : 0
  module_var_filesystem_hana_data                               = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_data
  module_var_physical_partition_filesystem_block_size_hana_data = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_data

  module_var_disk_volume_type_hana_log                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_log
  module_var_disk_volume_count_hana_log                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log
  module_var_disk_volume_capacity_hana_log                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_log
  module_var_disk_volume_iops_hana_log                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_log == "custom" ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_iops_hana_log : null
  module_var_lvm_enable_hana_log                               = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log
  module_var_lvm_pv_data_alignment_hana_log                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_log : 0
  module_var_lvm_vg_data_alignment_hana_log                    = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_log : 0
  module_var_lvm_vg_physical_extent_size_hana_log              = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_log : 0
  module_var_lvm_lv_stripe_size_hana_log                       = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_log : 0
  module_var_filesystem_hana_log                               = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_log
  module_var_physical_partition_filesystem_block_size_hana_log = var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_log

  module_var_disk_volume_type_hana_shared                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_shared
  module_var_disk_volume_count_hana_shared                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared
  module_var_disk_volume_capacity_hana_shared                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_shared
  module_var_disk_volume_iops_hana_shared                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_type_hana_shared == "custom" ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_iops_hana_shared : null
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


module "run_ansible_sap_hana_install" {

  depends_on = [module.run_host_provision_module]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_hana_install"

  # Terraform Module Variables using the prior Terraform Module Variables (from bootstrap module)
  module_var_bastion_boolean         = true // required as true boolean for any Cloud Service Provider (CSP)
  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key
  module_var_bastion_floating_ip     = module.run_bastion_inject_module.output_bastion_ip

  module_var_host_private_ssh_key = module.run_account_bootstrap_module.output_host_private_ssh_key


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
