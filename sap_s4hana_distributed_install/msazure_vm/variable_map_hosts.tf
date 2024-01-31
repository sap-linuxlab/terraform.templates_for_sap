
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP S/4HANA distributed install"

  type = map(any)

  default = {

    small_256gb = {

      hana-p = { // Hostname
        vm_instance = "Standard_M32ls"
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_count = 4
            disk_size = 64
            disk_type = "P6"
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
            disk_count = 3
            disk_size = 128
            disk_type = "P10"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 256
            disk_type = "P15"
            filesystem_type = "xfs"
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
            disk_size = 128
            disk_type = "E10"
            filesystem_type = "xfs"
          }
        ]
      },



      nw-ascs = { // Hostname
        vm_instance = "Standard_D32s_v5"
        storage_definition = [
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
            disk_size = 128
            disk_type = "E10"
            filesystem_type = "xfs"
          }
        ]
      },



      nw-pas = { // Hostname
        vm_instance = "Standard_D32s_v5"
        storage_definition = [
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
            disk_size = 128
            disk_type = "E10"
            filesystem_type = "xfs"
          }
        ]
      },



      nw-aas = { // Hostname
        vm_instance = "Standard_D32s_v5"
        storage_definition = [
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
            disk_size = 128
            disk_type = "E10"
            filesystem_type = "xfs"
          }
        ]
      }

    }

  }

}
