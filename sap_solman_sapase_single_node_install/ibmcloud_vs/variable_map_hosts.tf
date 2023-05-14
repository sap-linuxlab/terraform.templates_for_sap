
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP NetWeaver AS (ABAP) with SAP ASE single node install"

  type = map(any)

  default = {

    small_32vcpu = {

      nw01 = {  // Hostname
        virtual_server_profile = "bx2-32x128"

        // N.B. all capacities must be different from each other, due to Shell loop searching based on capacity GB

        disk_volume_count_hana_data   = 0

        disk_volume_count_hana_log    = 0

        disk_volume_count_hana_shared = 0

        disk_volume_count_anydb        = 2
        disk_volume_type_anydb         = "10iops-tier" // Does NOT use Burst IOPS storage.
        disk_volume_capacity_anydb     = 224
        #disk_volume_iops_anydb         = 
        lvm_enable_anydb               = true // if false, then disk volume count should be 1
        lvm_pv_data_alignment_anydb   = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        lvm_vg_data_alignment_anydb   = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        lvm_vg_physical_extent_size_anydb = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        lvm_lv_stripe_size_anydb       = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_mount_path_anydb    = "/sybase"
        filesystem_anydb               = "xfs"
        physical_partition_filesystem_block_size_anydb = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_usr_sap     = 1 // max of 1
        disk_volume_type_usr_sap      = "general-purpose"
        disk_volume_capacity_usr_sap  = 256
        filesystem_usr_sap            = "xfs"

        disk_volume_count_sapmnt      = 1 // max of 1
        disk_volume_type_sapmnt       = "general-purpose"
        disk_volume_capacity_sapmnt   = 56
        filesystem_sapmnt             = "xfs"

        #disk_swapfile_size_gb         = 2 // not required if disk volume set
        disk_volume_count_swap        = 1 // max of 1
        disk_volume_type_swap         = "general-purpose"
        disk_volume_capacity_swap     = 64
        filesystem_swap               = "xfs"

        disk_volume_type_software     = "5iops-tier"
        disk_volume_capacity_software = 150

      }

    }

  }

}
