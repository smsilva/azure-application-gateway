resource "azurerm_user_assigned_identity" "app_gw" {
  name                = local.application_gateway_name
  resource_group_name = azurerm_resource_group.app_gw.name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "app_gw_user_assigned_identity" {
  scope                = azurerm_application_gateway.app_gw.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.app_gw.principal_id

  depends_on = [
    azurerm_application_gateway.app_gw,
    azurerm_user_assigned_identity.app_gw
  ]
}

resource "azurerm_role_assignment" "app_gw_resource_group" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.app_gw.name}"
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.app_gw.principal_id

  depends_on = [
    azurerm_user_assigned_identity.app_gw
  ]
}
