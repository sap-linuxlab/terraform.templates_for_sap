
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP S/4HANA single node install"

  type = map(any)

  default = {

    small_256gb = {

      s4h01 = { // Hostname
        ibmpowervc_compute_cpu_threads = 32
        ibmpowervc_compute_ram_gb      = 256
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_size = 512
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
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 256
            filesystem_type = "xfs"
          },
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 32
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "/software"
            disk_size = 100
            filesystem_type = "xfs"
          }
        ]
      }


    }
  }
}
