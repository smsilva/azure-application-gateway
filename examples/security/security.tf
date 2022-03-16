data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "default" {
  name                = local.application_gateway_name
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "app_gw_user_assigned_identity" {
  scope                = azurerm_application_gateway.default.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.default.principal_id

  depends_on = [
    azurerm_application_gateway.default,
    azurerm_user_assigned_identity.default
  ]
}

resource "azurerm_role_assignment" "app_gw_resource_group" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.default.name}"
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.default.principal_id

  depends_on = [
    azurerm_user_assigned_identity.default
  ]
}
