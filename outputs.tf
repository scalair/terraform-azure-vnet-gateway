output "id" {
    value = azurerm_virtual_network_gateway.this.id
}

output "public_ip_id" {
    value = module.pubip.id
}

output "public_ip_address" {
    value = module.pubip.ip_address
}

output "public_ip_fqdn" {
    value = module.pubip.fqdn
}

output "local_network_gateways" {
    value = azurerm_local_network_gateway.this
}