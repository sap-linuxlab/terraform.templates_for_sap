
module "run_host_bootstrap_module" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//vmware_vm/host_bootstrap?ref=main"

}


module "run_host_provision_module" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//vmware_vm/host_provision?ref=main"

  # Set Terraform Module Variables using Terraform Variables at runtime

  module_var_resource_prefix = var.resource_prefix

  module_var_host_public_ssh_key  = module.run_host_bootstrap_module.output_host_public_ssh_key
  module_var_host_private_ssh_key = module.run_host_bootstrap_module.output_host_private_ssh_key


  module_var_vmware_vcenter_server = var.vmware_vcenter_server
  module_var_vmware_vcenter_user = var.vmware_vcenter_user
  module_var_vmware_vcenter_user_password = var.vmware_vcenter_user_password

  module_var_vmware_vsphere_datacenter_name = var.vmware_vsphere_datacenter_name
  module_var_vmware_vsphere_datacenter_compute_cluster_name = var.vmware_vsphere_datacenter_compute_cluster_name
  module_var_vmware_vsphere_datacenter_compute_cluster_host_fqdn = var.vmware_vsphere_datacenter_compute_cluster_host_fqdn

  module_var_vmware_vsphere_datacenter_compute_cluster_folder_name = var.vmware_vsphere_datacenter_compute_cluster_folder_name
  module_var_vmware_vsphere_datacenter_storage_datastore_name = var.vmware_vsphere_datacenter_storage_datastore_name
  module_var_vmware_vsphere_datacenter_network_primary_name = var.vmware_vsphere_datacenter_network_primary_name


  module_var_vmware_vm_template_name = var.vmware_vm_template_name


  module_var_vmware_vm_dns_root_domain_name = var.dns_root_domain

  module_var_web_proxy_url       = var.web_proxy_url
  module_var_web_proxy_exclusion = "localhost,127.0.0.1,${var.dns_root_domain}" // Web Proxy exclusion list for hosts running on VMware vSphere (e.g. localhost,127.0.0.1,custom.root.domain)

  module_var_os_vendor_account_user          = var.os_vendor_account_user
  module_var_os_vendor_account_user_passcode = var.os_vendor_account_user_passcode
  module_var_os_systems_mgmt_host            = var.os_systems_mgmt_host

  # Set Terraform Module Variables using for_each loop on a map Terraform Variable with nested objects

  for_each = toset([
    for key, value in (length(var.map_host_specifications) != 0 ? var.map_host_specifications[var.host_specification_plan] : local.map_host_specifications_defaults[var.ansible_sap_scenario_selection][var.host_specification_plan]) : key
  ])

  module_var_vmware_vm_hostname = each.key

  module_var_vmware_vm_compute_cpu_threads  = (length(var.map_host_specifications) != 0 ? var.map_host_specifications[var.host_specification_plan] : local.map_host_specifications_defaults[var.ansible_sap_scenario_selection][var.host_specification_plan])[each.key].vmware_vm_compute_cpu_threads
  module_var_vmware_vm_compute_ram_gb       = (length(var.map_host_specifications) != 0 ? var.map_host_specifications[var.host_specification_plan] : local.map_host_specifications_defaults[var.ansible_sap_scenario_selection][var.host_specification_plan])[each.key].vmware_vm_compute_ram_gb

  module_var_storage_definition = [ for storage_item in (length(var.map_host_specifications) != 0 ? var.map_host_specifications[var.host_specification_plan] : local.map_host_specifications_defaults[var.ansible_sap_scenario_selection][var.host_specification_plan])[each.key]["storage_definition"] : storage_item if contains(keys(storage_item),"disk_size") && try(storage_item.swap_path,"") == "" ]

}


module "run_ansible" {

  depends_on = [module.run_host_provision_module]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_playbooks_for_sap?ref=main"

  # Terraform Module Variables using the prior Terraform Module Variables (from bootstrap module)
  module_var_bastion_boolean         = true // required as true boolean for any Cloud Service Provider (CSP)
  module_var_bastion_user            = var.bastion_user
  module_var_bastion_ssh_port        = var.bastion_ssh_port
  module_var_bastion_private_ssh_key = module.run_account_bootstrap_module.output_bastion_private_ssh_key
  module_var_bastion_floating_ip     = module.run_bastion_inject_module.output_bastion_ip

  module_var_host_private_ssh_key = module.run_account_bootstrap_module.output_host_private_ssh_key

  module_var_host_specifications     = (length(var.map_host_specifications) != 0 ? var.map_host_specifications : local.map_host_specifications_defaults[var.ansible_sap_scenario_selection] )
  module_var_host_specification_plan = var.host_specification_plan
  module_var_host_provision_outputs  = module.run_host_provision_module

  module_var_nfs_fqdn_sapmnt    = try(module.run_host_nfs_module[0].output_nfs_fqdn_sapmnt,"")
  module_var_nfs_fqdn_transport = try(module.run_host_nfs_module[0].output_nfs_fqdn_transport,"")

  module_var_dns_root_domain = var.dns_root_domain

  module_var_ansible_sap_scenario_selection = var.ansible_sap_scenario_selection
  module_var_ansible_sap_software_product   = var.ansible_sap_software_product

  module_var_ansible_sap_system_sid = try(var.sap_system_sid,"")
  module_var_ansible_sap_system_hana_db_sid = try(var.sap_system_hana_db_sid,"")
  module_var_ansible_sap_system_hana_db_instance_nr = try(var.sap_system_hana_db_instance_nr,"")
  module_var_ansible_sap_system_anydb_sid = try(var.sap_system_anydb_sid,"")
  module_var_ansible_sap_system_nwas_abap_ascs_instance_nr = try(var.sap_system_nwas_abap_ascs_instance_nr,"")
  module_var_ansible_sap_system_nwas_abap_pas_instance_nr  = try(var.sap_system_nwas_abap_pas_instance_nr,"")
  module_var_ansible_sap_system_nwas_abap_aas_instance_nr  = try(var.sap_system_nwas_abap_aas_instance_nr,"")
  module_var_ansible_sap_system_nwas_java_scs_instance_nr  = try(var.sap_system_nwas_java_scs_instance_nr,"")
  module_var_ansible_sap_system_nwas_java_ci_instance_nr   = try(var.sap_system_nwas_java_ci_instance_nr,"")
  module_var_ansible_sap_maintenance_planner_transaction_name = try(var.sap_maintenance_planner_transaction_name,"")
  module_var_ansible_sap_software_download_directory = var.sap_software_download_directory

  module_var_ansible_sap_id_user          = var.sap_id_user
  module_var_ansible_sap_id_user_password = var.sap_id_user_password

}
