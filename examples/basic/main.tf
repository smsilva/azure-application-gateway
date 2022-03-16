# Create an Application Gateway ingress controller in Azure Kubernetes Service
# https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-aks-applicationgateway-ingress
#
# Secure traffic with a web application firewall (WAF)
# https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-network#secure-traffic-with-a-web-application-firewall-waf

locals {
  location                 = "eastus2"
  application_gateway_name = "wasp-app-gw-example-1"
  virtual_network_name     = "vnet-public"
  virtual_network_cidrs    = ["10.244.0.0/14"]
  virtual_network_subnets = [
    { cidr = "10.247.2.0/27", name = "app-gw" }
  ]
}

resource "azurerm_resource_group" "default" {
  name     = local.application_gateway_name
  location = local.location
}

module "vnet" {
  source = "git@github.com:smsilva/azure-network.git//src/vnet?ref=3.0.5"

  name                = local.virtual_network_name
  cidrs               = local.virtual_network_cidrs
  subnets             = local.virtual_network_subnets
  resource_group_name = azurerm_resource_group.default.name

  depends_on = [
    azurerm_resource_group.default
  ]
}

module "application_gateway" {
  source = "../../src"

  name      = local.application_gateway_name
  location  = local.location
  subnet_id = module.vnet.subnets["app-gw"].instance.id
}

output "module_application_gateway_outputs" {
  value = module.application_gateway
}
