

variable "map_ibm_powervs_to_vpc_az" {

  description = "Map of IBM Power VS location to the colocated IBM Cloud VPC Infrastructure Availability Zone"

  type = map(any)

  default = {

    dal12    = "us-south-2"
    us-south = "us-south-3" // naming of IBM Power VS location 'us-south' was previous naming convention, would otherwise be 'DAL13'
    us-east  = "us-east-1"  // naming of IBM Power VS location 'us-east' was previous naming convention, would otherwise be 'WDC04'
    # wdc06    = "us-east-2" // No Cloud Connection available at this location
    sao01    = "br-sao-1"
    tor01    = "ca-tor-1"
    eu-de-1  = "eu-de-2" // naming of IBM Power VS location 'eu-de-1' was previous naming convention, would otherwise be 'FRA04'
    eu-de-2  = "eu-de-3" // naming of IBM Power VS location 'eu-de-2' was previous naming convention, would otherwise be 'FRA05'
    lon04    = "eu-gb-1"
    lon06    = "eu-gb-3"
    syd04    = "au-syd-2"
    syd05    = "au-syd-3"
    tok04    = "jp-tok-2"
    osa21    = "jp-osa-1"

  }

}


# IBM Cloud Regional API Endpoint = https://<<ibmcloud_region>>.cloud.ibm.com/
# IBM Power VS (on IBM Cloud) Regional API Endpoint = https://<<ibmpowervs_region>>.power-iaas.cloud.ibm.com/
variable "map_ibm_powervs_location_to_powervs_region" {

  description = "Map of IBM Power VS location to the secured IBM Power VS Region API Endpoints"

  type = map(any)

  default = {

    dal12    = "us-south"
    us-south = "us-south"
    us-east  = "us-east"
    # wdc06    = "us-east" // no Cloud Connection available at this location
    sao01    = "sao"
    tor01    = "tor"
    eu-de-1  = "eu-de"
    eu-de-2  = "eu-de"
    lon04    = "lon"
    lon06    = "lon"
    syd04    = "syd"
    syd05    = "syd"
    tok04    = "tok"
    osa21    = "osa"

  }

}
