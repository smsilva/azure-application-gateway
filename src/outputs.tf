output "id" {
  value = azurerm_application_gateway.app_gw.id
}

output "name" {
  value = azurerm_application_gateway.app_gw.name
}

output "resource_group_name" {
  value = azurerm_application_gateway.app_gw.resource_group_name
}

output "location" {
  value = azurerm_application_gateway.app_gw.location
}

output "zones" {
  value = azurerm_application_gateway.app_gw.zones
}

output "tags" {
  value = azurerm_application_gateway.app_gw.tags
}

output "public_ip_id" {
  value = azurerm_public_ip.app_gw.id
}

output "public_ip_address" {
  value = azurerm_public_ip.app_gw.ip_address
}

output "public_ip_fqdn" {
  value = azurerm_public_ip.app_gw.fqdn
}
