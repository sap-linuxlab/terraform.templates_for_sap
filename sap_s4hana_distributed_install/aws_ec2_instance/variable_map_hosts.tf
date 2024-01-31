
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP S/4HANA distributed install"

  type = map(any)

  default = {

    small_256gb = {

      hana-p = { // Hostname
        ec2_instance_type = "r5.8xlarge"
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_size = 384
            disk_type = "gp3"
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
            disk_type = "gp3"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 320
            disk_type = "gp3"
            filesystem_type = "xfs"
          },
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "gp3"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "gp3"
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
            disk_type = "gp3"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-ascs = { // Hostname
        ec2_instance_type = "m5.8xlarge"
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "gp3"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "gp3"
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
            disk_type = "gp3"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-pas = { // Hostname
        ec2_instance_type = "m5.8xlarge"
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "gp3"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "gp3"
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
            disk_type = "gp3"
            filesystem_type = "xfs"
          }
        ]
      },


      nw-aas = { // Hostname
        ec2_instance_type = "m5.8xlarge"
        storage_definition = [
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "gp3"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "gp3"
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
            disk_type = "gp3"
            filesystem_type = "xfs"
          }
        ]
      }


    }
  }
}
