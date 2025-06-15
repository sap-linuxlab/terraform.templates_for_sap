# NOTE:
# Passwords (e.g. DDIC) for SAP System and components cannot be changed from these 'Terraform Templates for SAP'
# For greater flexibility and additional complex scenarios, please directly use the 'Ansible Playbooks for SAP'


variable "sap_id_user" {
  description = "Ansible - Please enter your SAP ID user (e.g. S-User)"
}

variable "sap_id_user_password" {
  description = "Ansible - Please enter your SAP ID password"
}

variable "sap_system_sid" {
  description = "Ansible - SAP System ID (e.g. S01)"
  default     = "S01"
}

variable "sap_system_hana_db_sid" {
  description = "Ansible - SAP HANA install: System ID (e.g. H01)"
  default     = "H01"
}

variable "sap_system_hana_db_instance_nr" {
  description = "Ansible - SAP HANA install: Instance Number (e.g. 90)"
  default     = "90"
  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_system_hana_db_instance_nr))
  }
}

variable "sap_system_anydb_sid" {
  description = "Ansible - SAP AnyDB install: System ID (e.g. DB2, OR1, AS1, MX1)"
  default     = "AY1"
}

variable "sap_system_nwas_abap_ascs_instance_nr" {
  description = "Ansible - SAP NetWeaver AS (ABAP) - ABAP Central Services (ASCS) instance number"
  default = "00"
  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_system_nwas_abap_ascs_instance_nr))
  }
}

variable "sap_system_nwas_abap_pas_instance_nr" {
  description = "Ansible - SAP NetWeaver AS (ABAP) - Primary Application Server instance number"
  default = "01"
  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_system_nwas_abap_pas_instance_nr))
  }
}

variable "sap_system_nwas_abap_aas_instance_nr" {
  description = "Ansible - SAP NetWeaver AS (ABAP) - Additional Application Server instance number"
  default = "11"
  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_system_nwas_abap_aas_instance_nr))
  }
}

variable "sap_system_nwas_java_scs_instance_nr" {
  description = "Ansible - SAP NetWeaver AS (JAVA) - JAVA Central Services (SCS) instance number"
  default = "20"
  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_system_nwas_java_scs_instance_nr))
  }
}

variable "sap_system_nwas_java_ci_instance_nr" {
  description = "Ansible - SAP NetWeaver AS (JAVA) - JAVA Central Instance instance number"
  default = "21"
  validation {
    error_message = "Cannot use Instance Number 43 (HA port number) or 89 (Windows Remote Desktop Services)."
    condition = !can(regex("(43|89)", var.sap_system_nwas_java_ci_instance_nr))
  }
}

variable "sap_maintenance_planner_transaction_name" {
  description = "Ansible - OPTIONAL: SAP Maintenance Planner Transaction name for SAP S/4HANA, required to perform download of this stack"
  default     = ""
}

variable "sap_software_download_directory" {
  description = "Ansible - Mount point for downloads of SAP Software"
  default     = "/software"
  validation {
    error_message = "Directory must start with forward slash."
    condition = can(regex("^/", var.sap_software_download_directory))
  }
}


### Ansible Playbooks for SAP - scenario selection
## sap_hana
## sap_bw4hana_sandbox
## sap_ecc_hana_sandbox
## sap_ides_ecc_hana_sandbox
## sap_nwas_abap_hana_sandbox
## sap_s4hana_foundation_sandbox
## sap_s4hana_sandbox
## sap_s4hana_sandbox_maintplan
## sap_solman_saphana_sandbox
##
## sap_ecc_ibmdb2_sandbox
## sap_ecc_oracledb_sandbox
## sap_ecc_sapase_sandbox
## sap_ecc_sapmaxdb_sandbox
## sap_ides_ecc_ibmdb2_sandbox
## sap_nwas_abap_ibmdb2_sandbox
## sap_nwas_abap_oracledb_sandbox
## sap_nwas_abap_sapase_sandbox
## sap_nwas_abap_sapmaxdb_sandbox
## sap_nwas_java_ibmdb2_sandbox
## sap_nwas_java_sapase_sandbox
## sap_solman_sapase_sandbox
##
## sap_ecc_ibmdb2_distributed
## sap_s4hana_foundation_standard
## sap_s4hana_standard
## sap_s4hana_standard_maintplan
## sap_s4hana_distributed
## sap_s4hana_distributed_maintplan

# Ignored/Unavailable Ansible Playbook for SAP scenarios via Terraform Templates
## sap_hana_ha
## sap_hana_scaleout
## sap_ecc_ibmdb2_distributed_ha
## sap_bw4hana_standard_scaleout
## sap_landscape_s4hana_standard
## sap_landscape_s4hana_standard_maintplan
## sap_s4hana_distributed_ha
## sap_s4hana_distributed_ha_maintplan

variable "ansible_sap_scenario_selection" {
  description = "Ansible - Ansible Playbook for SAP scenario to execute"
}


### Ansible Playbooks for SAP - scenario software version
## sap_hana_2_sps08_install
## sap_hana_2_sps07_install
## sap_hana_2_sps06_install
## sap_bw4hana_2023_sandbox
## sap_bw4hana_2021_sandbox
## sap_bw4hana_2023_standard
## sap_bw4hana_2021_standard
## sap_s4hana_2023_sandbox
## sap_s4hana_2022_sandbox
## sap_s4hana_2021_sandbox
## sap_s4hana_2020_sandbox
## sap_s4hana_2023_standard
## sap_s4hana_2022_standard
## sap_s4hana_2021_standard
## sap_s4hana_2020_standard
## sap_s4hana_2023_distributed
## sap_s4hana_2022_distributed
## sap_s4hana_2021_distributed
## sap_s4hana_2020_distributed
## sap_s4hana_fndn_2023_sandbox
## sap_s4hana_fndn_2022_sandbox
## sap_s4hana_fndn_2021_sandbox
## sap_s4hana_fndn_2023_standard
## sap_s4hana_fndn_2022_standard
## sap_s4hana_fndn_2021_standard
## sap_ecc6_ehp8_hana_sandbox
## sap_ecc6_ehp7_hana_sandbox
## sap_ecc6_ehp8_ibmdb2_sandbox
## sap_ecc6_ehp7_ibmdb2_sandbox
## sap_ecc6_ehp8_oracledb_sandbox
## sap_ecc6_ehp8_sapase_sandbox
## sap_ecc6_ehp8_sapmaxdb_sandbox
## sap_ecc6_ehp8_ibmdb2_distributed
## sap_ides_ecc6_ehp8_hana_sandbox
## sap_ides_ecc6_ehp8_ibmdb2_sandbox
## sap_nwas_752_sp00_abap_hana_sandbox
## sap_nwas_752_sp00_abap_ibmdb2_sandbox
## sap_nwas_752_sp00_abap_oracledb_sandbox
## sap_nwas_752_sp00_abap_sapase_sandbox
## sap_nwas_752_sp00_abap_sapmaxdb_sandbox
## sap_nwas_750_sp00_abap_hana_sandbox
## sap_nwas_750_sp00_abap_ibmdb2_sandbox
## sap_nwas_750_sp00_abap_oracledb_sandbox
## sap_nwas_750_sp00_abap_sapase_sandbox
## sap_nwas_750_sp00_abap_sapmaxdb_sandbox
## sap_nwas_750_sp22_java_ibmdb2_sandbox_ads
## sap_nwas_750_sp22_java_sapase_sandbox_ads
## sap_solman_72_sr2_sapase_sandbox
## sap_solman_72_sr2_saphana_sandbox

variable "ansible_sap_software_product" {
  description = "Ansible - Ansible Playbook for SAP scenario's product version to deploy"
}
