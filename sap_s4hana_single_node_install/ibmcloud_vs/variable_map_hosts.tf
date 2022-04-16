
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP S/4HANA single node install"

  type = map(any)

  default = {

    small_256gb = {

      s4h01 = {
        virtual_server_profile = "mx2-32x256"

        // N.B. all capacities must be different from each other, due to Shell loop searching based on capacity GB

        disk_volume_count_hana_data    = 3
        disk_volume_type_hana_data     = "10iops-tier"
        disk_volume_capacity_hana_data = 128
        #disk_volume_iops_hana_data = 
        lvm_enable_hana_data                  = true  // if false, then disk volume count should be 1
        lvm_pv_data_alignment_hana_data       = "1M"  //default 1MiB offset from disk start before first LVM PV Physical Extent.
        lvm_vg_data_alignment_hana_data       = "1M"  //default 1MiB offset from disk start before first LVM VG Physical Extent.
        lvm_vg_physical_extent_size_hana_data = "4M"  //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        lvm_lv_stripe_size_hana_data          = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_data                  = "xfs"
        #physical_partition_filesystem_block_size_hana_data = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_hana_log    = 3
        disk_volume_type_hana_log     = "10iops-tier"
        disk_volume_capacity_hana_log = 48
        #disk_volume_iops_hana_log = 
        lvm_enable_hana_log                  = true  // if false, then disk volume count should be 1
        lvm_pv_data_alignment_hana_log       = "1M"  //default 1MiB offset from disk start before first LVM PV Physical Extent.
        lvm_vg_data_alignment_hana_log       = "1M"  //default 1MiB offset from disk start before first LVM VG Physical Extent.
        lvm_vg_physical_extent_size_hana_log = "4M"  //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        lvm_lv_stripe_size_hana_log          = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_log                  = "xfs"
        #physical_partition_filesystem_block_size_hana_log = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_hana_shared    = 1
        disk_volume_type_hana_shared     = "10iops-tier" // Does NOT use Burst IOPS storage. Approx same cost as 1TB at lower IOPS Tiers, use lower capacity and increase to 10IOPS/GB to ensure quicker DB Backup Restore from /hana/shared/<system_id>/HDB<instance_no>/backup/data/DB_<suffix>
        disk_volume_capacity_hana_shared = 320
        #disk_volume_iops_hana_shared = 
        lvm_enable_hana_shared = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_shared = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_shared = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_shared = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_shared = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_shared = "xfs"
        physical_partition_filesystem_block_size_hana_shared = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_usr_sap    = 1 // max of 1
        disk_volume_type_usr_sap     = "general-purpose"
        disk_volume_capacity_usr_sap = 64
        filesystem_usr_sap           = "xfs"

        disk_volume_count_sapmnt    = 1 // max of 1
        disk_volume_type_sapmnt     = "general-purpose"
        disk_volume_capacity_sapmnt = 56
        filesystem_sapmnt           = "xfs"

        #disk_swapfile_size_gb = 2 // not required if disk volume set
        disk_volume_count_swap    = 1 // max of 1
        disk_volume_type_swap     = "5iops-tier"
        disk_volume_capacity_swap = 32
        filesystem_swap           = "xfs"
      }

    }

  }
}
