resource_tags = ["sap", "sapecc"]

resource_prefix = "sap"

dns_root_domain = "poc.cloud"

bastion_os_image = "rhel-8-4"

bastion_user = "bastionuser"

bastion_ssh_port = 50222

host_specification_plan = "small_256gb"

host_os_image = "rhel-8-1-sap-ha-byol"

disk_volume_capacity_software = 368

disk_volume_type_software = "tier1"

sap_hana_install_master_password = "NewPass$321"

sap_hana_install_sid = "H01"

sap_hana_install_instance_number = "10"

sap_nwas_ascs_instance_no = "00"

sap_nwas_pas_instance_no = "02"

sap_ecc_hana_install_sid = "E01"

sap_software_download_directory = "/software"
