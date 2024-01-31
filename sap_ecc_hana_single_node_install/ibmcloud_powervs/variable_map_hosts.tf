
variable "map_host_specifications" {

  description = "Map of host specficiations for SAP ECC on SAP HANA single node install"

  type = map(any)

  default = {

    small_256gb = {

      ecc01 = { // Hostname
        virtual_server_profile = "ush1-4x256"
        // An IBM PowerVS host will be set to Tier 1 or Tier 3 storage type, and cannot use block storage volumes from both storage types
        // Therefore all block storage volumes are provisioned with Tier 1 (this cannot be changed once provisioned)
        // https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-about-virtual-server#storage-tiers
        storage_definition = [
          {
            name = "hana_data"
            mountpoint = "/hana/data"
            disk_size = 384
            disk_type = "tier1"
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
            disk_size = 144
            disk_type = "tier1"
            filesystem_type = "xfs"
          },
          {
            name = "hana_shared"
            mountpoint = "/hana/shared"
            disk_size = 256
            disk_type = "tier1"
            filesystem_type = "xfs"
          },
          {
            name = "usr_sap"
            mountpoint = "/usr/sap"
            disk_size = 96
            disk_type = "tier1"
            filesystem_type = "xfs"
          },
          {
            name = "sapmnt"
            mountpoint = "/sapmnt"
            disk_size = 96
            disk_type = "tier1"
            filesystem_type = "xfs"
          },
          {
            name = "swap"
            mountpoint = "/swap"
            disk_size = 32
            disk_type = "tier1"
            filesystem_type = "swap"
          },
          {
            name = "software"
            mountpoint = "/software"
            disk_size = 100
            disk_type = "tier1"
            filesystem_type = "xfs"
          }
        ]
      }


    }
  }
}
