
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP ECC on IBM DB2 single node install"

  type = map(any)

  default = {

    small_32vcpu = {

      ecc01 = {  // Hostname
        virtual_machine_profile       = "n2-standard-32" // 32 vCPU, 128GB Memory

        // N.B. all capacities must be different from each other, due to Shell loop searching based on capacity GB

        disk_volume_count_hana_data   = 0

        disk_volume_count_hana_log    = 0

        disk_volume_count_hana_shared = 0

        disk_volume_count_anydb       = 0

        disk_volume_count_usr_sap     = 1 // max of 1
        disk_volume_type_usr_sap      = "pd-standard"
        disk_volume_capacity_usr_sap  = 64
        filesystem_usr_sap            = "xfs"

        disk_volume_count_sapmnt      = 0 // max of 1
        disk_volume_type_sapmnt       = "pd-standard"
        disk_volume_capacity_sapmnt   = 56
        filesystem_sapmnt             = "xfs"
        nfs_boolean_sapmnt            = true

        #disk_swapfile_size_gb         = 2 // not required if disk volume set
        disk_volume_count_swap        = 1 // max of 1
        disk_volume_type_swap         = "pd-standard"
        disk_volume_capacity_swap     = 96
        filesystem_swap               = "xfs"

        disk_volume_type_software     = "pd-standard"
        disk_volume_capacity_software = 100
      }

    }

  }

}

