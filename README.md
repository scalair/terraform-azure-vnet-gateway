# Terraform Azure Virtual Network Gateway

This module creates a VNet gateway with an associated public IP.

## Usage example

```hcl
module "aks" {
  source = "github.com/scalair/terraform-azure-vnet-gateway"

  name                = "gw_name"
  location            = "francecentral"
  resource_group_name = "rg_name"

  sku        = "VpnGw1"
  generation = "Generation1"

  subnet_id = "/subnet/id"
  private_ip_address_allocation = "Dynamic"

  public_ip_sku = "Basic"
  public_ip_allocation_method = "Dynamic"

  client_address_space = ["10.10.0.0/22"]

  client_root_certificates = {
    "DigiCert-Federated-ID-Root-CA" = "MIID......Qqk=" // Base-64 encoded X.509
  }

  client_revoked_certificates = {
    "Verizon-Global-Root-CA" = "9121......49B1" // SHA1 thumbprint
  }

  client_protocols = ["SSTP", "IkeV2", "OpenVPN"]

  tags = {}
}
```

## What is not (yet) implemented

- P2S connection
- BGP support
- Active/Active mode
- RADIUS Authentication
- ExpressRoute type
- PolicyBased VPN
