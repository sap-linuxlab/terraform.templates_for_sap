
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP NetWeaver AS (ABAP) with IBM DB2 single node install"

  type = map(any)

  default = {

    small_32vcpu = {

      nw01 = { // Hostname
        virtual_machine_profile = "n2-standard-32" // 32 vCPU, 128GB Memory
        storage_definition = [
          {
            name = "db2"
            mountpoint = "/db2"
            disk_count = 2
            disk_size = 320
            disk_type = "pd-standard" // Uses Burst IOPS for storage. May increase costs if there is consistent heavy usage (e.g. longer than 30mins burst, such as 200GB+ DB Backup Restore)
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
            disk_size = 136 // minimum 128GB swap for IBM DB2 LUW
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "/software"
            disk_size = 100
            disk_type = "pd-standard"
            filesystem_type = "xfs"
          }
        ]
      }


    }
  }
}
