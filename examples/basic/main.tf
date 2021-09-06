locals {
  platform_instance_name = "wasp-sandbox-62w5ec"
  location               = "centralus"
}

resource "azurerm_resource_group" "default" {
  name     = local.platform_instance_name
  location = local.location
}

resource "azurerm_virtual_network" "default" {
  name                = "${azurerm_resource_group.default.name}-vnet"
  address_space       = ["10.100.0.0/16"]
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

resource "random_string" "subnet_id" {
  keepers = {
    platform_instance_name = local.platform_instance_name
    cluster_location       = local.location
  }

  length      = 6
  min_numeric = 3
  special     = false
  upper       = false
}

resource "azurerm_subnet" "default" {
  name                 = "subnet-${random_string.subnet_id.result}"
  address_prefixes     = ["10.100.2.0/27"]
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = azurerm_resource_group.default.name
}

//module "application_gateway" {
//  source = "../../src"
//
//  name                       = "app-gw"
//  platform_instance_name     = "wasp-sandbox-62w5ec"
//  resource_group_name        = azurerm_resource_group.default.name
//  location                   = azurerm_resource_group.default.location
//  subnet_id                  = ""
//  log_analytics_workspace_id = ""
//}

output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "subnet_id" {
  value = azurerm_subnet.default.id
}
