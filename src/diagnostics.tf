resource "azurerm_log_analytics_workspace" "default" {
  name                = local.application_gateway_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "default" {
  name                       = local.application_gateway_name
  target_resource_id         = azurerm_application_gateway.default.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id

  dynamic "log" {
    for_each = [
      "ApplicationGatewayAccessLog",
      "ApplicationGatewayPerformanceLog",
      "ApplicationGatewayFirewallLog"
    ]

    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = false
        days    = 30
      }
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
      days    = 30
    }
  }

  depends_on = [
    azurerm_application_gateway.default,
    azurerm_log_analytics_workspace.default
  ]
}
