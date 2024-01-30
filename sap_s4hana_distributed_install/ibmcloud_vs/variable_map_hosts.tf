
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP S/4HANA distributed install"

  type = map(any)

  default = {

    small_256gb = {

      hana-p = { // Hostname
        virtual_server_profile = "mx2-32x256"
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_count = 3
            disk_size = 128
            disk_type = "10iops-tier"
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
            disk_size = 48
            disk_type = "10iops-tier"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 320
            disk_type = "5iops-tier"
            filesystem_type = "xfs"
          },
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "general-purpose"
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
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-ascs = { // Hostname
        virtual_server_profile = "bx2-16x64"
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "/software"
            disk_size = 100
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-pas = { // Hostname
        virtual_server_profile = "bx2-16x64"
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "/software"
            disk_size = 200
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-aas = { // Hostname
        virtual_server_profile = "bx2-16x64"
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 96
            disk_type = "general-purpose"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "/software"
            disk_size = 100
            disk_type = "general-purpose"
            filesystem_type = "xfs"
          }
        ]
      }

    }

  }
}
