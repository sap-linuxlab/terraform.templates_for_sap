
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP NetWeaver AS (JAVA) with IBM Db2 single node install"

  type = map(any)

  default = {

    small_32vcpu = {

      nw01 = {  // Hostname
        vm_instance = "Standard_D32s_v5"

        // N.B. all capacities must be different from each other, due to Shell loop searching based on capacity GB

        disk_volume_count_hana_data   = 0

        disk_volume_count_hana_log    = 0

        disk_volume_count_hana_shared = 0

        disk_volume_count_anydb    = 1
        disk_volume_type_anydb     = "P20" // Uses Burst IOPS for storage. May increase costs if there is consistent heavy usage (e.g. longer than 30mins burst, such as 200GB+ DB Backup Restore)
        disk_volume_capacity_anydb = 512
        #disk_volume_iops_anydb = 
        lvm_enable_anydb = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_anydb = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_anydb = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_anydb = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_anydb = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_mount_path_anydb    = "/db2"
        filesystem_anydb               = "xfs"
        physical_partition_filesystem_block_size_anydb = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_usr_sap    = 1 // max of 1
        disk_volume_type_usr_sap     = "E15"
        disk_volume_capacity_usr_sap = 256
        filesystem_usr_sap           = "xfs"

        disk_volume_count_sapmnt    = 1 // max of 1
        disk_volume_type_sapmnt     = "E6"
        disk_volume_capacity_sapmnt = 64 // bad sizing, but use this so each drive size is unique
        filesystem_sapmnt           = "xfs"

        #disk_swapfile_size_gb  = 2 // not required if disk volume set
        disk_volume_count_swap = 1 // max of 1
        disk_volume_type_swap = "E10"
        disk_volume_capacity_swap = 128 // minimum 128GB swap for IBM DB2 LUW
        filesystem_swap = "xfs"
      }

    }

  }

}
