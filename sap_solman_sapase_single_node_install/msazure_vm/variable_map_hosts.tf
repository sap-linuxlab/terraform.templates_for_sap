
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP NetWeaver AS (JAVA) with SAP ASE single node install"

  type = map(any)

  default = {

    small_32vcpu = {

      nw01 = { // Hostname
        vm_instance = "Standard_D32s_v5"
        storage_definition = [
          {
            name = "sybase"
            mountpoint = "/sybase"
            disk_size = 512
            disk_type = "P20"
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
            disk_size = 128
            disk_type = "E10"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 128
            disk_type = "E10"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 32
            disk_type = "E4"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "/software"
            disk_size = 200
            disk_type = "E10"
            filesystem_type = "xfs"
          }
        ]
      }


    }
  }
}
