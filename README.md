# Terraform Azure Virtual Network Gateway

This module creates a VNet gateway with an associated public IP.

More details [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway).

## Usage example

```hcl
module "vnet_gateway" {
  source = "github.com/scalair/terraform-azure-vnet-gateway"

  name                = "gw_name"
  resource_group_name = "rg_name"
  sku        = "VpnGw1"
  generation = "Generation1"

  public_ip_sku = "Basic"
  subnet_id = "/subnet/id"

  bgp_asn = "65515" // Set this to enable bgp

  local_gateways = [
    {
      name            = "local_site_1",
      gateway_address = "12.13.14.15",
      address_space   = "10.0.0.0/16",
      shared_key      = "4-v3ry-53cr37-1p53c-5h4r3d-k3y",
      bgp_asn         = "65515" // Set this to enable bgp
    }
  ]

  tags = {}
}
```

## What is not (yet) implemented

- P2S connection
- Active/Active mode
- RADIUS Authentication
- ExpressRoute type
- PolicyBased VPN
