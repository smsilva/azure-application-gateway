locals {
  application_gateway_name = var.name
  resource_group_name      = var.resource_group_name != "" ? var.resource_group_name : local.application_gateway_name
  resource_group_location  = var.location
}

variable "name" {
  type    = string
  default = "app-gw"
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "resource_group_name" {
  type    = string
  default = ""
}

resource "azurerm_resource_group" "default" {
  name     = local.resource_group_name
  location = local.resource_group_location
}

# module "appgw" {
#   source = "git@github.com:smsilva/azure-application-gateway.git//src?ref=1.1.1"

#   name           = local.application_gateway_name
#   resource_group = azurerm_resource_group.default
#   subnet_id      = module.vnet.subnets["app-gw"].instance.id

#   depends_on = [
#     module.vnet
#   ]
# }

output "list" {
  value = {
    name                    = local.application_gateway_name
    resource_group_id       = azurerm_resource_group.default.id
    resource_group_name     = azurerm_resource_group.default.name
    resource_group_location = azurerm_resource_group.default.location
  }
}
