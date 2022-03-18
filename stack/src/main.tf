locals {
  application_gateway_name = var.name
  resource_group_name      = var.resource_group_name != "" ? var.resource_group_name : local.application_gateway_name
  resource_group_location  = var.location
}

resource "azurerm_resource_group" "default" {
  name     = local.resource_group_name
  location = local.resource_group_location
}

module "appgw" {
  source = "../../src"

  name           = local.application_gateway_name
  resource_group = azurerm_resource_group.default
  subnet         = var.subnet_id

  depends_on = [
    module.vnet
  ]
}
