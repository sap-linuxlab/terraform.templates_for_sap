
module "run_ansible_dry_run" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_nwas_abap_hana_install?ref=main"

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
  module_var_sap_swpm_template_selected       = var.sap_swpm_template_selected

}


module "run_account_init_module" {

  depends_on = [
    module.run_ansible_dry_run
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/account_init?ref=main"

  module_var_resource_prefix = var.resource_prefix

  module_var_aws_vpc_subnet_id = var.aws_vpc_subnet_id

  module_var_aws_vpc_subnet_create_boolean = local.aws_vpc_subnet_create_boolean

  module_var_aws_vpc_availability_zone     = var.aws_vpc_availability_zone

}


module "run_account_bootstrap_module" {

  depends_on = [
    module.run_account_init_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/account_bootstrap?ref=main"

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

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/bastion_inject?ref=main"

  module_var_resource_prefix = var.resource_prefix

  module_var_aws_vpc_subnet_id = local.aws_vpc_subnet_create_boolean ? module.run_account_init_module.output_aws_vpc_subnet_id : var.aws_vpc_subnet_id
  module_var_aws_vpc_igw_id    = module.run_account_init_module.output_aws_vpc_igw_id

  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_os_image        = var.map_os_image_regex[var.bastion_os_image]
  module_var_bastion_ssh_key_name    = module.run_account_bootstrap_module.output_bastion_ssh_key_name
  module_var_bastion_public_ssh_key  = module.run_account_bootstrap_module.output_bastion_public_ssh_key
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

  module_var_aws_vpc_availability_zone = var.aws_vpc_availability_zone

}


module "run_host_network_access_sap_module" {

  depends_on = [
    module.run_bastion_inject_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/host_network_access_sap?ref=main"

  module_var_resource_prefix = var.resource_prefix

  module_var_aws_vpc_subnet_id = local.aws_vpc_subnet_create_boolean ? module.run_account_init_module.output_aws_vpc_subnet_id : var.aws_vpc_subnet_id
  module_var_host_security_group_id = module.run_account_bootstrap_module.output_host_security_group_id

  module_var_sap_nwas_abap_pas_instance_no = var.sap_nwas_abap_pas_instance_no
  module_var_sap_hana_instance_no     = var.sap_hana_install_instance_number

}


module "run_host_network_access_sap_public_via_proxy_module" {

  depends_on = [
    module.run_bastion_inject_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/host_network_access_sap_public_via_proxy?ref=main"

  module_var_resource_prefix = var.resource_prefix

  module_var_aws_vpc_subnet_id = local.aws_vpc_subnet_create_boolean ? module.run_account_init_module.output_aws_vpc_subnet_id : var.aws_vpc_subnet_id

  module_var_bastion_sg_id = module.run_bastion_inject_module.output_bastion_security_group_id
  module_var_bastion_connection_sg_id = module.run_bastion_inject_module.output_bastion_connection_security_group_id

  module_var_sap_nwas_abap_pas_instance_no = var.sap_nwas_abap_pas_instance_no
  module_var_sap_hana_instance_no     = var.sap_hana_install_instance_number

}


module "run_host_provision_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//aws_ec2_instance/host_provision?ref=main"

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

  module_var_storage_definition = [ for storage_item in var.map_host_specifications[var.host_specification_plan][each.key]["storage_definition"] : storage_item if contains(keys(storage_item),"disk_size") && try(storage_item.swap_path,"") == "" ]

  module_var_disable_ip_anti_spoofing = false

}


module "run_ansible_sap_nwas_abap_hana_install" {

  depends_on = [module.run_host_provision_module]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_nwas_abap_hana_install?ref=main"


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

  module_var_sap_hana_install_master_password = var.sap_hana_install_master_password
  module_var_sap_hana_install_sid             = var.sap_hana_install_sid
  module_var_sap_hana_install_instance_number = var.sap_hana_install_instance_number

  module_var_sap_swpm_sid                     = var.sap_nwas_install_sid

  module_var_sap_swpm_db_schema_abap          = "SAPHANADB"
  module_var_sap_swpm_db_schema_abap_password = var.sap_hana_install_master_password
  module_var_sap_swpm_db_system_password      = var.sap_hana_install_master_password
  module_var_sap_swpm_db_systemdb_password    = var.sap_hana_install_master_password
  module_var_sap_swpm_db_sidadm_password      = var.sap_hana_install_master_password
  module_var_sap_swpm_ddic_000_password       = var.sap_hana_install_master_password
  module_var_sap_swpm_pas_instance_nr         = var.sap_nwas_abap_pas_instance_no
  module_var_sap_swpm_ascs_instance_nr        = var.sap_nwas_abap_ascs_instance_no

  module_var_sap_swpm_master_password         = var.sap_hana_install_master_password

  module_var_sap_swpm_template_selected       = var.sap_swpm_template_selected

  module_var_sap_software_download_directory  = var.sap_software_download_directory

  module_var_terraform_host_specification_storage_definition = var.map_host_specifications[var.host_specification_plan][join(", ", each.value.*.output_host_name)]["storage_definition"]

}
