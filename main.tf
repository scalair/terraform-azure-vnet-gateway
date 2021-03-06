data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

module "pubip" {
  source = "github.com/scalair/terraform-azure-public-ip?ref=v0.2.0"

  name                = "pubip-${var.name}"
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = var.public_ip_sku
  allocation_method   = "Dynamic"
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = var.sku
  generation          = var.generation
  active_active       = false

  ip_configuration {
    name                          = "ipconf-${var.name}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
    public_ip_address_id          = module.pubip.id
  }

  enable_bgp = var.bgp_asn != ""
  dynamic bgp_settings {
    for_each = var.bgp_asn != "" ? ["present"] : []
    content {
      asn = var.bgp_asn
    }
  }

  tags = var.tags
}

resource "azurerm_local_network_gateway" "this" {
  for_each = { for i, g in var.local_gateways : i => g }

  name                = each.value.name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  gateway_address     = each.value.gateway_address
  address_space       = each.value.address_space

  dynamic bgp_settings {
    for_each = lookup(each.value, "bgp_asn", "") != "" ? ["present"] : []
    content {
      asn                 = lookup(each.value, "bgp_asn", null)
      bgp_peering_address = lookup(each.value, "bgp_peering_address", null)
      peer_weight         = lookup(each.value, "bgp_peer_weight", null)
    }
  }

  tags = var.tags
}

resource "azurerm_virtual_network_gateway_connection" "this" {
  for_each = { for i, g in var.local_gateways : i => g }

  name                       = each.value.name
  location                   = data.azurerm_resource_group.this.location
  resource_group_name        = data.azurerm_resource_group.this.name
  
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.this.id
  local_network_gateway_id   = azurerm_local_network_gateway.this[each.key].id
  
  enable_bgp                 = lookup(each.value, "bgp_asn", null)

  shared_key = lookup(each.value, "shared_key", null)

  dynamic ipsec_policy {
    for_each = lookup(each.value, "ipsec_policy", [])

    content {
      dh_group         = ipsec_policy.value.dh_group
      ike_encryption   = ipsec_policy.value.ike_encryption
      ike_integrity    = ipsec_policy.value.ike_integrity
      ipsec_encryption = ipsec_policy.value.ipsec_encryption
      ipsec_integrity  = ipsec_policy.value.ipsec_integrity
      pfs_group        = ipsec_policy.value.pfs_group
      sa_datasize      = ipsec_policy.value.sa_datasize
      sa_lifetime      = ipsec_policy.value.sa_lifetime
    }
  }

  tags = var.tags
}
