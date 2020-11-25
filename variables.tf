variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "VpnGw1"
}

variable "generation" {
  type    = string
  default = "Generation1"
}

variable "bgp_asn" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type = string
}

variable "public_ip_sku" {
  type    = string
  default = "Basic"
}

variable "local_gateways" {
  type    = list
  default = []
}

variable "tags" {
  type    = map
  default = {}
}
