resource "azurerm_user_assigned_identity" "app_gw" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.name
  tags                = var.tags
}

resource "azurerm_role_assignment" "app-gw-aks" {
  scope                = azurerm_application_gateway.app_gw.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.app_gw.principal_id

  depends_on = [
    azurerm_application_gateway.app_gw,
    azurerm_user_assigned_identity.app_gw
  ]
}

resource "azurerm_role_assignment" "app-gw-aks-rg" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.app_gw.principal_id

  depends_on = [
    azurerm_user_assigned_identity.app_gw
  ]
}
