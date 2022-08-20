

variable "map_ibm_powervs_to_vpc_az" {

  description = "Map of IBM Power VS location to the colocated IBM Cloud VPC Infrastructure Availability Zone"

  type = map(any)

  default = {

    DAL12    = "us-south-2"
    us-south = "us-south-3" // naming of IBM Power VS location 'us-south' was previous naming convention, would otherwise be 'DAL13'
    us-east  = "us-east-1"  // naming of IBM Power VS location 'us-east' was previous naming convention, would otherwise be 'WDC04'
    WDC06    = "us-east-2"
    SAO01    = "br-sao-1"
    TOR01    = "ca-tor-1"
    eu-de-1  = "eu-de-2" // naming of IBM Power VS location 'us-de-1' was previous naming convention, would otherwise be 'FRA04'
    eu-de-2  = "eu-de-3" // naming of IBM Power VS location 'us-de-1' was previous naming convention, would otherwise be 'FRA05'
    LON04    = "eu-gb-1"
    LON06    = "eu-gb-3"
    SYD04    = "au-syd-2"
    SYD05    = "au-syd-3"
    TOK04    = "jp-tok-2"
    OSA21    = "jp-osa-1"

  }

}
