
variable "host_specification_plan" {
  description = "Host specification plan - e.g. xsmall_256gb for SAP HANA based, or xsmall_anydb_32vcpu for SAP AnyDB based. This variable uses the locals mapping with a nested list of host specifications, and will alter host provisioning."
}

variable "map_host_specifications" {
  description = "Map of host specficiations - will override defaults"
  type        = map(any)
  default     = {}
}


# Terraform Map of default host specifications for each Ansible Playbook for SAP scenario
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


locals {

map_host_specifications_defaults_sandbox = {

  sap_sandbox_hana = {  // SAP solution scenario from Ansible Playbooks for SAP
    xsmall_256gb = {    // Host Specifications Plan
      sap-hdb-sbx = {   // Hostname
        virtual_machine_profile = "n2-highmem-32"
        sap_host_type = "hana_primary" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_host_type = [ "hana_primary", "nwas_abap_ascs", "nwas_abap_pas" ]
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_count = 1
            disk_size = 384
            disk_type = "pd-ssd"
            #disk_iops =
            filesystem_type = "xfs"
            #lvm_lv_name =
            #lvm_lv_stripes =
            #lvm_lv_stripe_size =
            #lvm_vg_name =
            #lvm_vg_options =
            #lvm_vg_physical_extent_size =
            #lvm_pv_device =
            #lvm_pv_options =
            #nfs_path =
            #nfs_server =
            #nfs_filesystem_type =
            #nfs_mount_options =
          },
          {
            name = "hana_log"
            mountpoint = "/hana/log"
            disk_count = 1
            disk_size = 128
            disk_type = "pd-ssd"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 320
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            swap_path = "/swapfile"
            disk_size = 2
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 150
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      }
    }
  }

  sap_sandbox_anydb = {      // SAP solution scenario from Ansible Playbooks for SAP
    xsmall_anydb_32vcpu = {  // Host Specifications Plan
      sap-anydb-sbx = {      // Hostname
        virtual_machine_profile = "n2-standard-32"
        sap_host_type = "nwas_pas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_host_type = [ "nwas_abap_ascs", "nwas_abap_pas" ]
        storage_definition = [
          {
            name = "anydb"
            mountpoint = "/anydb" # should be /db2, /oracle, /sybase, /sapdb
            disk_count = 2
            disk_size = 224
            disk_type = "pd-ssd"
            #disk_iops =
            filesystem_type = "xfs"
            #lvm_lv_name =
            #lvm_lv_stripes =
            #lvm_lv_stripe_size =
            #lvm_vg_name =
            #lvm_vg_options =
            #lvm_vg_physical_extent_size =
            #lvm_pv_device =
            #lvm_pv_options =
            #nfs_path =
            #nfs_server =
            #nfs_filesystem_type =
            #nfs_mount_options =
          },
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 136 // 64 default, use minimum of 128GB swap for IBM DB2 LUW
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 150
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      }
    }
  }

}


map_host_specifications_defaults = {

  sap_hana = local.map_host_specifications_defaults_sandbox["sap_sandbox_hana"]
  sap_bw4hana_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_hana"]
  sap_ecc_hana_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_hana"]
  sap_ides_ecc_hana_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_hana"]
  sap_nwas_abap_hana_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_hana"]
  sap_s4hana_foundation_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_hana"]
  sap_s4hana_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_hana"]
  sap_s4hana_sandbox_maintplan = local.map_host_specifications_defaults_sandbox["sap_sandbox_hana"]
  sap_solman_saphana_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_hana"]

  sap_ecc_ibmdb2_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_ecc_oracledb_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_ecc_sapase_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_ecc_sapmaxdb_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_ides_ecc_ibmdb2_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_nwas_abap_ibmdb2_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_nwas_abap_oracledb_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_nwas_abap_sapase_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_nwas_abap_sapmaxdb_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_nwas_java_ibmdb2_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_nwas_java_sapase_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]
  sap_solman_sapase_sandbox = local.map_host_specifications_defaults_sandbox["sap_sandbox_anydb"]


  sap_s4hana_foundation_standard = {  // SAP solution scenario from Ansible Playbooks for SAP

    xsmall_256gb = {  // Host Specifications Plan

      sap-hana = {  // Hostname
        virtual_machine_profile = "n2-highmem-32"
        sap_host_type = "hana_primary" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_hana_db_sid,"H01")}"
        sap_storage_setup_host_type = [ "hana_primary" ]
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_count = 1
            disk_size = 384
            disk_type = "pd-ssd"
            #disk_iops =
            filesystem_type = "xfs"
            #lvm_lv_name =
            #lvm_lv_stripes =
            #lvm_lv_stripe_size =
            #lvm_vg_name =
            #lvm_vg_options =
            #lvm_vg_physical_extent_size =
            #lvm_pv_device =
            #lvm_pv_options =
            #nfs_path =
            #nfs_server =
            #nfs_filesystem_type =
            #nfs_mount_options =
          },
          {
            name = "hana_log"
            mountpoint = "/hana/log"
            disk_count = 1
            disk_size = 128
            disk_type = "pd-ssd"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 320
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            swap_path = "/swapfile"
            disk_size = 2
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },

      sap-nwas = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_pas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_pas" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 136 // 64 default, use minimum of 128GB swap for IBM DB2 LUW
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 150
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      }
    }
  }


  sap_s4hana_standard = {  // SAP solution scenario from Ansible Playbooks for SAP

    xsmall_256gb = {  // Host Specifications Plan

      sap-hana = {  // Hostname
        virtual_machine_profile = "n2-highmem-32"
        sap_host_type = "hana_primary" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_hana_db_sid,"H01")}"
        sap_storage_setup_host_type = [ "hana_primary" ]
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_count = 1
            disk_size = 384
            disk_type = "pd-ssd"
            #disk_iops =
            filesystem_type = "xfs"
            #lvm_lv_name =
            #lvm_lv_stripes =
            #lvm_lv_stripe_size =
            #lvm_vg_name =
            #lvm_vg_options =
            #lvm_vg_physical_extent_size =
            #lvm_pv_device =
            #lvm_pv_options =
            #nfs_path =
            #nfs_server =
            #nfs_filesystem_type =
            #nfs_mount_options =
          },
          {
            name = "hana_log"
            mountpoint = "/hana/log"
            disk_count = 1
            disk_size = 128
            disk_type = "pd-ssd"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 320
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            swap_path = "/swapfile"
            disk_size = 2
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },

      sap-nwas = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_pas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_pas" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 136 // 64 default, use minimum of 128GB swap for IBM DB2 LUW
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 150
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      }
    }
  }


  sap_s4hana_standard_maintplan = {  // SAP solution scenario from Ansible Playbooks for SAP

    xsmall_256gb = {  // Host Specifications Plan

      sap-hana = {  // Hostname
        virtual_machine_profile = "n2-highmem-32"
        sap_host_type = "hana_primary" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_hana_db_sid,"H01")}"
        sap_storage_setup_host_type = [ "hana_primary" ]
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_count = 1
            disk_size = 384
            disk_type = "pd-ssd"
            #disk_iops =
            filesystem_type = "xfs"
            #lvm_lv_name =
            #lvm_lv_stripes =
            #lvm_lv_stripe_size =
            #lvm_vg_name =
            #lvm_vg_options =
            #lvm_vg_physical_extent_size =
            #lvm_pv_device =
            #lvm_pv_options =
            #nfs_path =
            #nfs_server =
            #nfs_filesystem_type =
            #nfs_mount_options =
          },
          {
            name = "hana_log"
            mountpoint = "/hana/log"
            disk_count = 1
            disk_size = 128
            disk_type = "pd-ssd"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 320
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            swap_path = "/swapfile"
            disk_size = 2
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },

      sap-nwas = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_pas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_pas" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 136 // 64 default, use minimum of 128GB swap for IBM DB2 LUW
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 150
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      }
    }
  }


  sap_s4hana_distributed = {  // SAP solution scenario from Ansible Playbooks for SAP

    xsmall_256gb = {  // Host Specifications Plan

      hana-p = {  // Hostname
        virtual_machine_profile = "n2-highmem-32"
        sap_host_type = "hana_primary" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_hana_db_sid,"H01")}"
        sap_storage_setup_host_type = [ "hana_primary" ]
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_count = 1
            disk_size = 384
            disk_type = "pd-ssd"
            #disk_iops =
            filesystem_type = "xfs"
            #lvm_lv_name =
            #lvm_lv_stripes =
            #lvm_lv_stripe_size =
            #lvm_vg_name =
            #lvm_vg_options =
            #lvm_vg_physical_extent_size =
            #lvm_pv_device =
            #lvm_pv_options =
            #nfs_path =
            #nfs_server =
            #nfs_filesystem_type =
            #nfs_mount_options =
          },
          {
            name = "hana_log"
            mountpoint = "/hana/log"
            disk_count = 1
            disk_size = 128
            disk_type = "pd-ssd"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 320
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            swap_path = "/swapfile"
            disk_size = 2
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 200
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-ascs = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_ascs" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_ascs" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "usr_sap_trans"
            mountpoint = "/usr/sap/trans"
            nfs_path = "/usr/sap/trans"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-pas = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_pas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_pas" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "usr_sap_trans"
            mountpoint = "/usr/sap/trans"
            nfs_path = "/usr/sap/trans"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 200
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-aas = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_aas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_aas" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "usr_sap_trans"
            mountpoint = "/usr/sap/trans"
            nfs_path = "/usr/sap/trans"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      }


    }
  }


  sap_s4hana_distributed_maintplan = {  // SAP solution scenario from Ansible Playbooks for SAP

    xsmall_256gb = {  // Host Specifications Plan

      hana-p = {  // Hostname
        virtual_machine_profile = "n2-highmem-32"
        sap_host_type = "hana_primary" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_hana_db_sid,"H01")}"
        sap_storage_setup_host_type = [ "hana_primary" ]
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_count = 1
            disk_size = 384
            disk_type = "pd-ssd"
            #disk_iops =
            filesystem_type = "xfs"
            #lvm_lv_name =
            #lvm_lv_stripes =
            #lvm_lv_stripe_size =
            #lvm_vg_name =
            #lvm_vg_options =
            #lvm_vg_physical_extent_size =
            #lvm_pv_device =
            #lvm_pv_options =
            #nfs_path =
            #nfs_server =
            #nfs_filesystem_type =
            #nfs_mount_options =
          },
          {
            name = "hana_log"
            mountpoint = "/hana/log"
            disk_count = 1
            disk_size = 128
            disk_type = "pd-ssd"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 320
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            swap_path = "/swapfile"
            disk_size = 2
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 200
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-ascs = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_ascs" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_ascs" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "usr_sap_trans"
            mountpoint = "/usr/sap/trans"
            nfs_path = "/usr/sap/trans"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-pas = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_pas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_pas" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "usr_sap_trans"
            mountpoint = "/usr/sap/trans"
            nfs_path = "/usr/sap/trans"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 200
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-aas = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_aas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_aas" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "usr_sap_trans"
            mountpoint = "/usr/sap/trans"
            nfs_path = "/usr/sap/trans"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      }


    }
  }


  sap_ecc_ibmdb2_distributed = {  // SAP solution scenario from Ansible Playbooks for SAP

    xsmall_anydb_32vcpu = {  // Host Specifications Plan

      anydb-primary = {  // Hostname
        virtual_machine_profile = "n2-standard-32"
        sap_host_type = "anydb_primary" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_host_type = [ "nwas_abap_ascs", "nwas_abap_pas" ]
        storage_definition = [
          {
            name = "anydb"
            mountpoint = "/anydb" # should be /db2, /oracle, /sybase, /sapdb
            disk_count = 2
            disk_size = 640
            disk_type = "pd-ssd"
            #disk_iops =
            filesystem_type = "xfs"
            #lvm_lv_name =
            #lvm_lv_stripes =
            #lvm_lv_stripe_size =
            #lvm_vg_name =
            #lvm_vg_options =
            #lvm_vg_physical_extent_size =
            #lvm_pv_device =
            #lvm_pv_options =
            #nfs_path =
            #nfs_server =
            #nfs_filesystem_type =
            #nfs_mount_options =
          },
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 136 // 64 default, use minimum of 128GB swap for IBM DB2 LUW
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 150
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-ascs = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_ascs" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_ascs" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "usr_sap_trans"
            mountpoint = "/usr/sap/trans"
            nfs_path = "/usr/sap/trans"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-pas = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_pas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_pas" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "usr_sap_trans"
            mountpoint = "/usr/sap/trans"
            nfs_path = "/usr/sap/trans"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 200
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-aas = {  // Hostname
        virtual_machine_profile = "n2-standard-16"
        sap_host_type = "nwas_aas" # hana_primary, hana_secondary, nwas_ascs, nwas_ers, nwas_pas, nwas_aas
        sap_storage_setup_sid = "${try(var.sap_system_sid,"S01")}"
        sap_storage_setup_host_type = [ "nwas_abap_aas" ]
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            nfs_path = "/usr/sap"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "usr_sap_trans"
            mountpoint = "/usr/sap/trans"
            nfs_path = "/usr/sap/trans"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            nfs_path = "/sapmnt"
            nfs_server = ""
            nfs_filesystem_type = "nfs3"
            nfs_mount_options = "vers=3,mountvers=3,rw,relatime,hard,proto=tcp,timeo=600,retrans=2,mountport=2050,mountproto=tcp"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "pd-standard"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "${var.sap_software_download_directory}"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      }
    
    }
  }

}

}
