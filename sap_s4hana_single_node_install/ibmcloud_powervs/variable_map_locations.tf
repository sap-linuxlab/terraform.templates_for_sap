
variable "map_ibm_powervs_to_vpc_az" {

  description = "Map of IBM Power VS location to the colocated IBM Cloud VPC Infrastructure Availability Zone"

  type = map(any)

  default = {
    dal10    = "us-south-1"
    dal12    = "us-south-2"
    us-south = "us-south-3" // naming of IBM Power VS location 'us-south' was previous naming convention, would otherwise be 'dal13'
    us-east  = "us-east-1" // naming of IBM Power VS location 'us-east' was previous naming convention, would otherwise be 'wdc04'
    wdc06    = "us-east-2"
    wdc07    = "us-east-3"
    sao01    = "br-sao-1"
    sao02    = "br-sao-2"
    tor01    = "ca-tor-1"
    eu-de-1  = "eu-de-2" // naming of IBM Power VS location 'eu-de-1' was previous naming convention, would otherwise be 'fra04'
    eu-de-2  = "eu-de-3" // naming of IBM Power VS location 'eu-de-2' was previous naming convention, would otherwise be 'fra05'
    lon04    = "eu-gb-1"
    lon06    = "eu-gb-3"
    mad02    = "eu-es-1"
    mad04    = "eu-es-2"
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
    dal10    = "us-south"
    dal12    = "us-south"
    us-south = "us-south"
    us-east  = "us-east"
    wdc06    = "us-east" // no Cloud Connection available at this location
    wdc07    = "us-east" // no Cloud Connection available at this location
    sao01    = "sao"
    sao02    = "sao"
    tor01    = "tor"
    eu-de-1  = "eu-de"
    eu-de-2  = "eu-de"
    lon04    = "lon"
    lon06    = "lon"
    mad02    = "mad"
    mad04    = "mad"
    syd04    = "syd"
    syd05    = "syd"
    tok04    = "tok"
    osa21    = "osa"
  }

}
