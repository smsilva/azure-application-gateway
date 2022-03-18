locals {
  location                 = "eastus2"
  application_gateway_name = "wasp-app-gw-example-1"
  virtual_network_name     = "wasp-app-gw-example-1-vnet"
  virtual_network_cidrs    = ["10.244.0.0/14"]
  virtual_network_subnets = [
    { cidr = "10.247.2.0/27", name = "app-gw" }
  ]
}

module "application_gateway" {
  source = "../../src"

  name           = local.application_gateway_name
  resource_group = azurerm_resource_group.default
  subnet         = module.vnet.subnets["app-gw"].instance

  depends_on = [
    azurerm_resource_group.default
  ]
}

output "module_application_gateway_outputs" {
  value = module.application_gateway
}
