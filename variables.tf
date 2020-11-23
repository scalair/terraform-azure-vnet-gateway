variable "name" {
  type = string
}

variable "location" {
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

variable "private_ip_address_allocation" {
  type    = string
  default = "Dynamic"
}

variable "subnet_id" {
  type = string
}

variable "public_ip_allocation_method" {
  type    = string
  default = "Dynamic"
}

variable "public_ip_sku" {
  type    = string
  default = "Basic"
}

variable "client_address_space" {
  type = list(string)
}

variable "client_root_certificates" {
  type = map(string)
  default = {}
}

variable "client_revoked_certificates" {
  type = map(string)
  default = {}
}

variable "client_protocols" {
  type    = list(string)
  default = ["SSTP", "IkeV2", "OpenVPN"]
}

variable "tags" {
  type    = map
  default = {}
}
