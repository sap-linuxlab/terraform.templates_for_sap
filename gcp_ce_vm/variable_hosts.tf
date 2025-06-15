
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP S/4HANA single node install"

  type = map(any)

  default = {

    small_256gb = {

      hana01 = { // Hostname
        virtual_machine_profile = "n2-highmem-32" // 32 vCPU, 256GB Memory
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
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
            disk_size = 128
            disk_type = "pd-ssd"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 320
            disk_type = "pd-balanced" // Uses Burst IOPS for storage. May increase costs if there is consistent heavy usage (e.g. longer than 30mins burst, such as 200GB+ DB Backup Restore)
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
