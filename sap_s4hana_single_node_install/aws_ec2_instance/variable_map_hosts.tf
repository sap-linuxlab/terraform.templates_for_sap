
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP S/4HANA single node install"

  type = map(any)

  default = {

    small_256gb = {

      s4h01 = {
        ec2_instance_type = "r5.8xlarge"

        // N.B. all capacities must be different from each other, due to Shell loop searching based on capacity GB

        disk_volume_count_hana_data    = 1
        disk_volume_type_hana_data     = "gp3"
        disk_volume_capacity_hana_data = 320
        #disk_volume_iops_hana_data = 
        lvm_enable_hana_data = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_data = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_data = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_data = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_data = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_data                               = "xfs"
        physical_partition_filesystem_block_size_hana_data = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_hana_log    = 1
        disk_volume_type_hana_log     = "gp3"
        disk_volume_capacity_hana_log = 128
        #disk_volume_iops_hana_log = 
        lvm_enable_hana_log = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_log = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_log = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_log = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_log = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_log                               = "xfs"
        physical_partition_filesystem_block_size_hana_log = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_hana_shared    = 1
        disk_volume_type_hana_shared     = "gp3" // Uses Burst IOPS for storage. May increase costs if there is consistent heavy usage (e.g. longer than 30mins burst, such as 200GB+ DB Backup Restore)
        disk_volume_capacity_hana_shared = 320
        #disk_volume_iops_hana_shared = 
        lvm_enable_hana_shared = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_shared = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_shared = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_shared = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_shared = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_shared                               = "xfs"
        physical_partition_filesystem_block_size_hana_shared = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_usr_sap    = 0 // max of 1
        disk_volume_type_usr_sap     = "gp3"
        disk_volume_capacity_usr_sap = 64
        filesystem_usr_sap           = "xfs"

        disk_volume_count_sapmnt    = 0 // max of 1
        disk_volume_type_sapmnt     = "gp3"
        disk_volume_capacity_sapmnt = 50
        filesystem_sapmnt           = "xfs"

        disk_swapfile_size_gb  = 2 // not required if disk volume set
        disk_volume_count_swap = 0 // max of 1
        #disk_volume_type_swap = "gp3"
        #disk_volume_capacity_swap = 10
        #filesystem_swap = "xfs"
      }

    },

    small_256gb_ha = {

      s4h01p = {
        ec2_instance_type = "r5.8xlarge"

        // N.B. all capacities must be different from each other, due to Shell loop searching based on capacity GB

        disk_volume_count_hana_data    = 1
        disk_volume_type_hana_data     = "gp3"
        disk_volume_capacity_hana_data = 320
        #disk_volume_iops_hana_data = 
        lvm_enable_hana_data = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_data = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_data = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_data = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_data = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_data                               = "xfs"
        physical_partition_filesystem_block_size_hana_data = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_hana_log    = 1
        disk_volume_type_hana_log     = "gp3"
        disk_volume_capacity_hana_log = 128
        #disk_volume_iops_hana_log = 
        lvm_enable_hana_log = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_log = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_log = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_log = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_log = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_log                               = "xfs"
        physical_partition_filesystem_block_size_hana_log = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_hana_shared    = 1
        disk_volume_type_hana_shared     = "gp3" // Uses Burst IOPS for storage. May increase costs if there is consistent heavy usage (e.g. longer than 30mins burst, such as 200GB+ DB Backup Restore)
        disk_volume_capacity_hana_shared = 320
        #disk_volume_iops_hana_shared = 
        lvm_enable_hana_shared = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_shared = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_shared = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_shared = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_shared = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_shared                               = "xfs"
        physical_partition_filesystem_block_size_hana_shared = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_usr_sap    = 0 // max of 1
        disk_volume_type_usr_sap     = "gp3"
        disk_volume_capacity_usr_sap = 64
        filesystem_usr_sap           = "xfs"

        disk_volume_count_sapmnt    = 0 // max of 1
        disk_volume_type_sapmnt     = "gp3"
        disk_volume_capacity_sapmnt = 50
        filesystem_sapmnt           = "xfs"

        disk_swapfile_size_gb  = 2 // not required if disk volume set
        disk_volume_count_swap = 0 // max of 1
        #disk_volume_type_swap = "gp3"
        #disk_volume_capacity_swap = 10
        #filesystem_swap = "xfs"
      },

      s4h01s = {
        ec2_instance_type = "r5.8xlarge"

        // N.B. all capacities must be different from each other, due to Shell loop searching based on capacity GB

        disk_volume_count_hana_data    = 1
        disk_volume_type_hana_data     = "gp3"
        disk_volume_capacity_hana_data = 320
        #disk_volume_iops_hana_data = 
        lvm_enable_hana_data = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_data = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_data = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_data = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_data = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_data                               = "xfs"
        physical_partition_filesystem_block_size_hana_data = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_hana_log    = 1
        disk_volume_type_hana_log     = "gp3"
        disk_volume_capacity_hana_log = 128
        #disk_volume_iops_hana_log = 
        lvm_enable_hana_log = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_log = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_log = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_log = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_log = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_log                               = "xfs"
        physical_partition_filesystem_block_size_hana_log = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_hana_shared    = 1
        disk_volume_type_hana_shared     = "gp3" // Uses Burst IOPS for storage. May increase costs if there is consistent heavy usage (e.g. longer than 30mins burst, such as 200GB+ DB Backup Restore)
        disk_volume_capacity_hana_shared = 320
        #disk_volume_iops_hana_shared = 
        lvm_enable_hana_shared = false // if false, then disk volume count should be 1
        #lvm_pv_data_alignment_hana_shared = "1M" //default 1MiB offset from disk start before first LVM PV Physical Extent.
        #lvm_vg_data_alignment_hana_shared = "1M" //default 1MiB offset from disk start before first LVM VG Physical Extent.
        #lvm_vg_physical_extent_size_hana_shared = "4M" //default 4MiB, difficult to change once set. Akin to Physical Block Size.
        #lvm_lv_stripe_size_hana_shared = "64K" //default 64KiB. Akin to Virtualized Block Size.
        filesystem_hana_shared                               = "xfs"
        physical_partition_filesystem_block_size_hana_shared = "4k" // only if LVM is set to false; if XFS then only 4k value allowed otherwise will be overridden (see README about XFS and Page Size)

        disk_volume_count_usr_sap    = 0 // max of 1
        disk_volume_type_usr_sap     = "gp3"
        disk_volume_capacity_usr_sap = 64
        filesystem_usr_sap           = "xfs"

        disk_volume_count_sapmnt    = 0 // max of 1
        disk_volume_type_sapmnt     = "gp3"
        disk_volume_capacity_sapmnt = 50
        filesystem_sapmnt           = "xfs"

        disk_swapfile_size_gb  = 2 // not required if disk volume set
        disk_volume_count_swap = 0 // max of 1
        #disk_volume_type_swap = "gp3"
        #disk_volume_capacity_swap = 10
        #filesystem_swap = "xfs"
      }

    }

  }
}
