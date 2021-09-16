# Create an Application Gateway ingress controller in Azure Kubernetes Service
# https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-aks-applicationgateway-ingress
#
# Secure traffic with a web application firewall (WAF)
# https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-network#secure-traffic-with-a-web-application-firewall-waf

locals {
  location                = "centralus"
  name                    = "app-gw"
  virtual_network_name    = "vnet-public"
  virtual_network_cidrs   = ["10.200.0.0/16"]
  virtual_network_subnets = [{ cidr = "10.200.2.0/27", name = "app-gw" }]
}

module "vnet" {
  source = "git@github.com:smsilva/azure-network.git//src/vnet?ref=main"

  platform_instance_name = var.platform_instance_name
  location               = local.location
  name                   = local.virtual_network_name
  cidrs                  = local.virtual_network_cidrs
  subnets                = local.virtual_network_subnets
}

module "application_gateway" {
  source = "../../src"

  name                   = "app-gw"
  platform_instance_name = var.platform_instance_name
  location               = local.location
  subnet_id              = module.vnet.subnets["app-gw"].instance.id
}

output "module_application_gateway_outputs" {
  value = module.application_gateway
}
