data "azurerm_client_config" "current" {
}

locals {
  public_ip_name                 = "${var.name}-app-gw"
  backend_address_pool_name      = "${var.name}-beap"
  frontend_port_name             = "${var.name}-feport"
  frontend_ip_configuration_name = "${var.name}-feip"
  http_setting_name              = "${var.name}-be-htst"
  listener_name                  = "${var.name}-httplstn"
  request_routing_rule_name      = "${var.name}-rqrt"
}

resource "azurerm_public_ip" "app-gw-aks" {
  name                = local.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = var.public_ip_domain_name_label != null ? var.public_ip_domain_name_label : local.public_ip_name
  tags                = var.tags
}

resource "azurerm_user_assigned_identity" "app-gw-aks" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.name
  tags                = var.tags
}

resource "azurerm_application_gateway" "app-gw-aks" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = var.zones
  firewall_policy_id  = var.firewall_policy_id
  tags                = var.tags

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.autoscale_configuration == null ? var.sku_capacity : null
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
    public_ip_address_id = azurerm_public_ip.app-gw-aks.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
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
    azurerm_public_ip.app-gw-aks
  ]
}

resource "azurerm_role_assignment" "app-gw-aks" {
  scope                = azurerm_application_gateway.app-gw-aks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.app-gw-aks.principal_id

  depends_on = [
    azurerm_application_gateway.app-gw-aks,
    azurerm_user_assigned_identity.app-gw-aks
  ]
}

resource "azurerm_role_assignment" "app-gw-aks-rg" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.app-gw-aks.principal_id

  depends_on = [
    azurerm_user_assigned_identity.app-gw-aks
  ]
}

resource "azurerm_monitor_diagnostic_setting" "app-gw-aks" {
  name                       = var.name
  target_resource_id         = azurerm_application_gateway.app-gw-aks.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = ["ApplicationGatewayAccessLog", "ApplicationGatewayPerformanceLog", "ApplicationGatewayFirewallLog"]

    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = 0
      }
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 0
    }
  }

  depends_on = [
    azurerm_application_gateway.app-gw-aks
  ]
}