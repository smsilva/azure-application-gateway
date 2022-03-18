output "id" {
  value = "app-gw-id-value"
}

output "name" {
  value = local.application_gateway_name
}

output "resource_group_id" {
  value = azurerm_resource_group.default.id
}

output "resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "resource_group_location" {
  value = azurerm_resource_group.default.location
}
