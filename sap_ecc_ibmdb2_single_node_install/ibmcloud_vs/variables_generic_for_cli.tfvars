resource_tags = ["sap", "sapecc"]

resource_prefix = "sap"

dns_root_domain = "poc.cloud"

bastion_os_image = "rhel-8-4"

bastion_user = "bastionuser"

bastion_ssh_port = 50222

host_specification_plan = "small_32vcpu"

host_os_image = "rhel-8-4-sap-ha"

sap_anydb_install_master_password = "NewPass>321" // Do not use password with $ for IBM DB2 installations

sap_anydb_install_sid = "DB2"

sap_anydb_install_instance_number = "10"

sap_nwas_ascs_instance_no = "00"

sap_nwas_pas_instance_no = "02"

sap_ecc_install_sid = "E01"

sap_software_download_directory = "/software"
