
module "run_ansible_dry_run" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_s4hana_install_maintplan?ref=main"

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
  module_var_dns_root_domain_name             = ""
  module_var_sap_id_user                      = var.sap_id_user
  module_var_sap_id_user_password             = var.sap_id_user_password
  module_var_sap_swpm_sid                     = ""
  module_var_sap_swpm_db_schema_abap          = ""
  module_var_sap_swpm_db_schema_abap_password = ""
  module_var_sap_swpm_ddic_000_password       = ""
  module_var_sap_swpm_template_selected       = var.sap_swpm_template_selected
  module_var_sap_maintenance_planner_transaction_name = var.sap_maintenance_planner_transaction_name

}


module "run_account_init_module" {

  depends_on = [
    module.run_ansible_dry_run
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/account_init?ref=main"

  providers = { ibm = ibm.standard }

  module_var_resource_group_name           = local.resource_group_create_boolean ? 0 : var.ibmcloud_resource_group
  module_var_resource_group_create_boolean = local.resource_group_create_boolean

  module_var_resource_prefix = var.resource_prefix

  module_var_ibmcloud_vpc_subnet_name           = local.ibmcloud_vpc_subnet_create_boolean ? 0 : var.ibmcloud_vpc_subnet_name
  module_var_ibmcloud_vpc_subnet_create_boolean = local.ibmcloud_vpc_subnet_create_boolean
  module_var_ibmcloud_vpc_availability_zone     = var.map_ibm_powervs_to_vpc_az[lower(var.ibmcloud_powervs_location)]

}


module "run_account_bootstrap_module" {

  depends_on = [
    module.run_account_init_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/account_bootstrap?ref=main"

  providers = { ibm = ibm.standard }

  module_var_resource_group_id = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix   = var.resource_prefix

  module_var_ibmcloud_vpc_subnet_name           = local.ibmcloud_vpc_subnet_create_boolean ? module.run_account_init_module.output_vpc_subnet_name : var.ibmcloud_vpc_subnet_name
  module_var_ibmcloud_vpc_availability_zone     = var.map_ibm_powervs_to_vpc_az[lower(var.ibmcloud_powervs_location)]

  module_var_dns_root_domain_name = var.dns_root_domain

}


#module "run_account_iam_module" {
#
#  depends_on = [
#    module.run_account_bootstrap_module
#  ]
#
#  count = var.ibmcloud_iam_yesno == "yes" ? 1 : 0
#
#  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/account_iam?ref=main"
#
#  module_var_resource_group_id = module.run_account_init_module.output_resource_group_id
#  module_var_resource_prefix   = var.resource_prefix
#
#}


module "run_bastion_inject_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/bastion_inject?ref=main"

  providers = { ibm = ibm.standard }

  module_var_resource_group_id = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix   = var.resource_prefix
  module_var_resource_tags     = var.resource_tags

  module_var_ibmcloud_vpc_subnet_name = local.ibmcloud_vpc_subnet_create_boolean ? module.run_account_init_module.output_vpc_subnet_name : var.ibmcloud_vpc_subnet_name

  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_ssh_key_id      = module.run_account_bootstrap_module.output_bastion_ssh_key_id
  module_var_bastion_public_ssh_key  = module.run_account_bootstrap_module.output_bastion_public_ssh_key
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

  module_var_bastion_os_image = var.map_os_image_regex[var.bastion_os_image]

}


module "run_host_network_access_sap_public_via_proxy_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/host_network_access_sap_public_via_proxy?ref=main"

  providers = { ibm = ibm.standard }

  module_var_ibmcloud_vpc_subnet_name = local.ibmcloud_vpc_subnet_create_boolean ? module.run_account_init_module.output_vpc_subnet_name : var.ibmcloud_vpc_subnet_name

  module_var_bastion_security_group_id = module.run_bastion_inject_module.output_bastion_security_group_id
  module_var_bastion_connection_security_group_id = module.run_bastion_inject_module.output_bastion_connection_security_group_id
  module_var_host_security_group_id   = module.run_account_bootstrap_module.output_host_security_group_id

  module_var_sap_nwas_abap_pas_instance_no = var.sap_nwas_abap_pas_instance_no
  module_var_sap_hana_instance_no     = var.sap_hana_install_instance_number

}


module "run_account_bootstrap_powervs_workspace_module" {

  depends_on = [
    module.run_account_bootstrap_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_powervs/account_bootstrap_powervs_workspace?ref=main"

  # Define TF Module child provider name = TF Template parent provider name
  providers = {
    ibm.main = ibm.standard ,
    ibm.powervs_secure_enclave = ibm.powervs_secure_enclave
  }

  module_var_resource_group_id        = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix          = var.resource_prefix
  module_var_ibmcloud_power_zone      = lower(var.ibmcloud_powervs_location)
  module_var_ibmcloud_vpc_subnet_name = local.ibmcloud_vpc_subnet_create_boolean ? module.run_account_init_module.output_vpc_subnet_name : var.ibmcloud_vpc_subnet_name

}


module "run_account_bootstrap_powervs_networks_module" {

  depends_on = [
    module.run_account_bootstrap_module,
    module.run_account_bootstrap_powervs_workspace_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_powervs/account_bootstrap_powervs_networks?ref=main"

  # Define TF Module child provider name = TF Template parent provider name
  providers = {
    ibm.main = ibm.standard ,
    ibm.powervs_secure_enclave = ibm.powervs_secure_enclave
  }

  module_var_resource_group_id               = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix                 = var.resource_prefix
  module_var_ibmcloud_power_zone             = lower(var.ibmcloud_powervs_location)
  module_var_ibmcloud_powervs_workspace_guid = module.run_account_bootstrap_powervs_workspace_module.output_power_guid
  module_var_ibmcloud_vpc_crn                = module.run_account_bootstrap_powervs_workspace_module.output_power_target_vpc_crn
  module_var_ibmcloud_tgw_instance_name      = module.run_account_bootstrap_module.output_tgw_name

}


module "run_powervs_interconnect_sg_update_module" {

  depends_on = [
    module.run_bastion_inject_module,
    module.run_account_bootstrap_powervs_networks_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/powervs_interconnect_sg_update?ref=main"

  providers = { ibm = ibm.standard }

  module_var_bastion_security_group_id    = module.run_bastion_inject_module.output_bastion_security_group_id
  module_var_host_security_group_id       = module.run_account_bootstrap_module.output_host_security_group_id

  module_var_power_network_private_subnet = module.run_account_bootstrap_powervs_networks_module.output_power_network_private_subnet

}


module "run_powervs_interconnect_proxy_provision_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module,
    module.run_powervs_interconnect_sg_update_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_vs/powervs_interconnect_proxy_provision?ref=main"

  providers = { ibm = ibm.standard }

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

  module_var_virtual_server_profile = "cx2-8x16"

}


module "run_host_provision_module" {

  depends_on = [
    module.run_account_init_module,
    module.run_account_bootstrap_module,
    module.run_bastion_inject_module,
    module.run_powervs_interconnect_sg_update_module,
    module.run_powervs_interconnect_proxy_provision_module
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//ibmcloud_powervs/host_provision?ref=main"

  # Define TF Module child provider name = TF Template parent provider name
  providers = {
    ibm.main = ibm.standard ,
    ibm.powervs_secure_enclave = ibm.powervs_secure_enclave
  }

  module_var_resource_group_id = module.run_account_init_module.output_resource_group_id
  module_var_resource_prefix   = var.resource_prefix
  module_var_resource_tags     = var.resource_tags

  module_var_ibm_power_guid = module.run_account_bootstrap_powervs_workspace_module.output_power_guid
  module_var_power_networks = module.run_account_bootstrap_powervs_networks_module.output_power_networks

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

  module_var_dns_custom_resolver_ip = module.run_powervs_interconnect_proxy_provision_module.output_dns_custom_resolver_ip

  module_var_web_proxy_url       = "http://${module.run_powervs_interconnect_proxy_provision_module.output_proxy_private_ip}:${module.run_powervs_interconnect_proxy_provision_module.output_proxy_port_squid}"
  module_var_web_proxy_exclusion = "localhost,127.0.0.1,${var.dns_root_domain}" // Web Proxy exclusion list for hosts running on IBM Power (e.g. localhost,127.0.0.1,custom.root.domain)

  module_var_os_vendor_account_user          = var.os_vendor_account_user
  module_var_os_vendor_account_user_passcode = var.os_vendor_account_user_passcode

  # Set Terraform Module Variables using for_each loop on a map Terraform Variable with nested objects

  for_each = toset([
    for key, value in var.map_host_specifications[var.host_specification_plan] : key
  ])

  module_var_virtual_server_hostname = each.key

  module_var_hardware_machine_type  = var.map_host_specifications[var.host_specification_plan][each.key].hardware_machine_type
  module_var_virtual_server_profile = var.map_host_specifications[var.host_specification_plan][each.key].virtual_server_profile

  module_var_storage_definition = [ for storage_item in var.map_host_specifications[var.host_specification_plan][each.key]["storage_definition"] : storage_item if contains(keys(storage_item),"disk_size") && try(storage_item.swap_path,"") == "" ]


}


module "run_ansible_sap_s4hana_install_maintplan" {

  depends_on = [module.run_host_provision_module]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_s4hana_install_maintplan?ref=main"

  # Terraform Module Variables using the prior Terraform Module Variables (from bootstrap module)
  module_var_bastion_boolean         = true // required as true boolean for any Cloud Service Provider (CSP)
  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key

  module_var_bastion_floating_ip = module.run_bastion_inject_module.output_bastion_ip

  module_var_host_private_ssh_key = module.run_account_bootstrap_module.output_host_private_ssh_key


  # Set Terraform Module Variables using for_each loop on a map Terraform Variable at runtime

  for_each                        = module.run_host_provision_module
  module_var_host_private_ip      = join(", ", each.value.*.output_host_private_ip)
  module_var_hostname             = join(", ", each.value.*.output_host_name)
  module_var_dns_root_domain_name = var.dns_root_domain

  module_var_sap_id_user          = var.sap_id_user
  module_var_sap_id_user_password = var.sap_id_user_password

  module_var_sap_hana_install_master_password = var.sap_hana_install_master_password
  module_var_sap_hana_install_sid             = var.sap_hana_install_sid
  module_var_sap_hana_install_instance_number = var.sap_hana_install_instance_number

  module_var_sap_swpm_sid = var.sap_s4hana_install_sid

  module_var_sap_swpm_db_schema_abap          = "SAPHANADB"
  module_var_sap_swpm_db_schema_abap_password = var.sap_hana_install_master_password
  module_var_sap_swpm_db_system_password      = var.sap_hana_install_master_password
  module_var_sap_swpm_db_systemdb_password    = var.sap_hana_install_master_password
  module_var_sap_swpm_db_sidadm_password      = var.sap_hana_install_master_password
  module_var_sap_swpm_ddic_000_password       = var.sap_hana_install_master_password
  module_var_sap_swpm_pas_instance_nr         = var.sap_nwas_abap_pas_instance_no
  module_var_sap_swpm_ascs_instance_nr        = var.sap_nwas_abap_ascs_instance_no

  module_var_sap_swpm_master_password         = var.sap_hana_install_master_password

  module_var_sap_maintenance_planner_transaction_name = var.sap_maintenance_planner_transaction_name

  module_var_sap_swpm_template_selected = var.sap_swpm_template_selected

  module_var_sap_software_download_directory  = var.sap_software_download_directory

  module_var_terraform_host_specification_storage_definition = var.map_host_specifications[var.host_specification_plan][join(", ", each.value.*.output_host_name)]["storage_definition"]

}
