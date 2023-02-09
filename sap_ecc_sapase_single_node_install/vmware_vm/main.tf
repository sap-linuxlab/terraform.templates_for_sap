
module "run_ansible_dry_run" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_ecc_sapase_install?ref=dev"

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


module "run_host_bootstrap_module" {

  depends_on = [
    module.run_ansible_dry_run
  ]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//vmware_vm/host_bootstrap?ref=dev"

}


module "run_host_provision_module" {

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//vmware_vm/host_provision?ref=dev"

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
    for key, value in var.map_host_specifications[var.host_specification_plan] : key
  ])

  module_var_vmware_vm_hostname = each.key

  module_var_vmware_vm_compute_cpu_threads                        = var.map_host_specifications[var.host_specification_plan][each.key].vmware_vm_compute_cpu_threads
  module_var_vmware_vm_compute_ram_gb                             = var.map_host_specifications[var.host_specification_plan][each.key].vmware_vm_compute_ram_gb

  module_var_disk_volume_count_hana_data                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data
  module_var_disk_volume_capacity_hana_data                       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_data
  module_var_lvm_enable_hana_data                                 = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? false : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data
  module_var_lvm_pv_data_alignment_hana_data                      = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_data : 0
  module_var_lvm_vg_data_alignment_hana_data                      = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_data : 0
  module_var_lvm_vg_physical_extent_size_hana_data                = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_data : 0
  module_var_lvm_lv_stripe_size_hana_data                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_data : 0
  module_var_filesystem_hana_data                                 = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_data
  module_var_physical_partition_filesystem_block_size_hana_data   = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_data == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_data ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_data

  module_var_disk_volume_count_hana_log                           = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log
  module_var_disk_volume_capacity_hana_log                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_log
  module_var_lvm_enable_hana_log                                  = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? false : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log
  module_var_lvm_pv_data_alignment_hana_log                       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_log : 0
  module_var_lvm_vg_data_alignment_hana_log                       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_log : 0
  module_var_lvm_vg_physical_extent_size_hana_log                 = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_log : 0
  module_var_lvm_lv_stripe_size_hana_log                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_log : 0
  module_var_filesystem_hana_log                                  = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_log
  module_var_physical_partition_filesystem_block_size_hana_log    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_log == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_log ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_log

  module_var_disk_volume_count_hana_shared                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared
  module_var_disk_volume_capacity_hana_shared                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_hana_shared
  module_var_lvm_enable_hana_shared                               = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? false : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared
  module_var_lvm_pv_data_alignment_hana_shared                    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_hana_shared : 0
  module_var_lvm_vg_data_alignment_hana_shared                    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_hana_shared : 0
  module_var_lvm_vg_physical_extent_size_hana_shared              = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_hana_shared : 0
  module_var_lvm_lv_stripe_size_hana_shared                       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_hana_shared : 0
  module_var_filesystem_hana_shared                               = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_hana_shared
  module_var_physical_partition_filesystem_block_size_hana_shared = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_hana_shared == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_hana_shared ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_hana_shared

  module_var_disk_volume_count_anydb                              = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb
  module_var_disk_volume_capacity_anydb                           = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_anydb
  module_var_lvm_enable_anydb                                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? false : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb
  module_var_lvm_pv_data_alignment_anydb                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_pv_data_alignment_anydb : 0
  module_var_lvm_vg_data_alignment_anydb                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_data_alignment_anydb : 0
  module_var_lvm_vg_physical_extent_size_anydb                    = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_vg_physical_extent_size_anydb : 0
  module_var_lvm_lv_stripe_size_anydb                             = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? var.map_host_specifications[var.host_specification_plan][each.key].lvm_lv_stripe_size_anydb : 0
  module_var_filesystem_mount_path_anydb                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_mount_path_anydb
  module_var_filesystem_anydb                                     = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_anydb
  module_var_physical_partition_filesystem_block_size_anydb       = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].lvm_enable_anydb ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].physical_partition_filesystem_block_size_anydb

  module_var_disk_volume_count_usr_sap                            = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_usr_sap
  module_var_disk_volume_capacity_usr_sap                         = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_usr_sap
  module_var_filesystem_usr_sap                                   = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_usr_sap

  module_var_disk_volume_count_sapmnt                             = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_sapmnt
  module_var_disk_volume_capacity_sapmnt                          = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_sapmnt
  module_var_filesystem_sapmnt                                    = var.map_host_specifications[var.host_specification_plan][each.key].filesystem_sapmnt

  module_var_disk_swapfile_size_gb                                = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].disk_swapfile_size_gb
  module_var_disk_volume_count_swap                               = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap
  module_var_disk_volume_capacity_swap                            = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_swap : 0
  module_var_filesystem_swap                                      = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_swap > 0 ? var.map_host_specifications[var.host_specification_plan][each.key].filesystem_swap : 0

  module_var_disk_volume_capacity_software                        = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_capacity_software
  module_var_sap_software_download_directory                      = var.sap_software_download_directory

}


module "run_ansible_sap_ecc_sapase_install" {

  depends_on = [module.run_host_provision_module]

  source = "github.com/sap-linuxlab/terraform.modules_for_sap//all/ansible_sap_ecc_sapase_install?ref=dev"

  # Terraform Module Variables using the prior Terraform Module Variables (from bootstrap module)
  module_var_bastion_boolean         = var.bastion_boolean
  module_var_bastion_user            = var.bastion_boolean ? var.bastion_user : ""
  module_var_bastion_ssh_port        = var.bastion_boolean ? var.bastion_ssh_port : 0
  module_var_bastion_private_ssh_key = var.bastion_boolean ? var.bastion_private_ssh_key : 0
  module_var_bastion_floating_ip     = var.bastion_boolean ? var.bastion_ip : 0

  module_var_host_private_ssh_key = module.run_host_bootstrap_module.output_host_private_ssh_key


  # Set Terraform Module Variables using for_each loop on a map Terraform Variable at runtime

  for_each                           = module.run_host_provision_module
  module_var_host_private_ip         = join(", ", each.value.*.output_host_private_ip)
  module_var_hostname                = join(", ", each.value.*.output_host_name)
  module_var_dns_root_domain_name    = var.dns_root_domain

  module_var_sap_id_user                      = var.sap_id_user
  module_var_sap_id_user_password             = var.sap_id_user_password

  module_var_sap_anydb_install_sid             = var.sap_anydb_install_sid
  module_var_sap_anydb_install_instance_number = var.sap_anydb_install_instance_number

  module_var_sap_swpm_sid                     = var.sap_ecc_install_sid

  module_var_sap_swpm_db_schema_abap          = "ABAP"
  module_var_sap_swpm_db_schema_abap_password = var.sap_anydb_install_master_password
  module_var_sap_swpm_db_system_password      = var.sap_anydb_install_master_password
  module_var_sap_swpm_db_systemdb_password    = var.sap_anydb_install_master_password
  module_var_sap_swpm_db_sidadm_password      = var.sap_anydb_install_master_password
  module_var_sap_swpm_ddic_000_password       = var.sap_anydb_install_master_password
  module_var_sap_swpm_pas_instance_nr         = var.sap_nwas_abap_pas_instance_no
  module_var_sap_swpm_ascs_instance_nr        = var.sap_nwas_abap_ascs_instance_no

  module_var_sap_swpm_master_password         = var.sap_anydb_install_master_password

  module_var_sap_swpm_template_selected       = var.sap_swpm_template_selected

  module_var_filesystem_mount_path_anydb      = var.map_host_specifications[var.host_specification_plan][each.key].disk_volume_count_anydb == 0 ? 0 : var.map_host_specifications[var.host_specification_plan][each.key].filesystem_mount_path_anydb

  module_var_sap_software_download_directory  = var.sap_software_download_directory

}