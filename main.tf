module "pubip" {
  source = "github.com/scalair/terraform-azure-public-ip?ref=v0.0.1"

  name                = "pubip-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = var.sku
  generation    = var.generation

  ip_configuration {
    name                          = "ipconf-${var.name}"
    private_ip_address_allocation = var.private_ip_address_allocation
    subnet_id                     = var.subnet_id
    public_ip_address_id          = module.pubip.id
  }

  vpn_client_configuration {
    address_space = var.client_address_space

    dynamic root_certificate {
      for_each = var.client_root_certificates
      content {
        name             = each.key
        public_cert_data = each.value
      }
    }

    dynamic revoked_certificate {
      for_each = var.client_revoked_certificates
      content {
        name       = each.key
        thumbprint = each.value
      }
    }

    vpn_client_protocols = var.client_protocols
  }

  tags = var.tags
}
