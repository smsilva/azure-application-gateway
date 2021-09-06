output "id" {
  value = azurerm_application_gateway.app-gw-aks.id
}

output "name" {
  value = azurerm_application_gateway.app-gw-aks.name
}

output "resource_group_name" {
  value = azurerm_application_gateway.app-gw-aks.resource_group_name
}

output "location" {
  value = azurerm_application_gateway.app-gw-aks.location
}

output "zones" {
  value = azurerm_application_gateway.app-gw-aks.zones
}

output "tags" {
  value = azurerm_application_gateway.app-gw-aks.tags
}

output "public_ip_id" {
  value = azurerm_public_ip.app-gw-aks.id
}

output "public_ip_address" {
  value = azurerm_public_ip.app-gw-aks.ip_address
}

output "public_ip_fqdn" {
  value = azurerm_public_ip.app-gw-aks.fqdn
}
