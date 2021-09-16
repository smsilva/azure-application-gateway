data "azurerm_client_config" "current" {
}

resource "random_string" "application_gateway_id" {
  keepers = {
    platform_instance_name = var.platform_instance_name
    cluster_location       = var.location
    name                   = var.name
  }

  length      = 3
  min_numeric = 1
  min_lower   = 1
  special     = false
  upper       = false
}

locals {
  application_gateway_name       = "${var.platform_instance_name}-${var.name}-${random_string.application_gateway_id.result}"
  public_ip_name                 = "${var.platform_instance_name}-${var.name}-${random_string.application_gateway_id.result}-pip"
  backend_address_pool_name      = "${var.platform_instance_name}-${var.name}-${random_string.application_gateway_id.result}-be-ap"
  frontend_port_name             = "${var.platform_instance_name}-${var.name}-${random_string.application_gateway_id.result}-fe-port"
  frontend_ip_configuration_name = "${var.platform_instance_name}-${var.name}-${random_string.application_gateway_id.result}-fe-ip"
  http_setting_name              = "${var.platform_instance_name}-${var.name}-${random_string.application_gateway_id.result}-be-htst"
  listener_name                  = "${var.platform_instance_name}-${var.name}-${random_string.application_gateway_id.result}-http-listener"
  request_routing_rule_name      = "${var.platform_instance_name}-${var.name}-${random_string.application_gateway_id.result}-rqrt"
}

resource "azurerm_resource_group" "app_gw" {
  name     = local.application_gateway_name
  location = var.location
}

resource "azurerm_public_ip" "app_gw" {
  name                = local.public_ip_name
  resource_group_name = azurerm_resource_group.app_gw.name
  location            = var.location
  sku                 = var.public_ip_sku
  allocation_method   = var.public_ip_allocation_method
  domain_name_label   = var.public_ip_domain_name_label != null ? var.public_ip_domain_name_label : local.public_ip_name
  tags                = var.tags
}

resource "azurerm_application_gateway" "app_gw" {
  name                = local.application_gateway_name
  resource_group_name = azurerm_resource_group.app_gw.name
  location            = var.location
  zones               = var.zones
  firewall_policy_id  = var.firewall_policy_id
  tags                = var.tags

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.autoscale_configuration == null ? var.sku_capacity : 1
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? { config = var.autoscale_configuration } : {}
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  gateway_ip_configuration {
    name      = var.name
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gw.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 3
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      identity,
      probe,
      redirect_configuration,
      request_routing_rule,
      ssl_certificate,
      tags["ingress-for-aks-cluster-id"],
      tags["last-updated-by-k8s-ingress"],
      tags["managed-by-k8s-ingress"],
      url_path_map
    ]
  }

  depends_on = [
    azurerm_public_ip.app_gw
  ]
}
