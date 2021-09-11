resource "azurerm_log_analytics_workspace" "app_gw" {
  name                = local.application_gateway_name
  location            = var.location
  resource_group_name = azurerm_resource_group.app_gw.name
  sku                 = "Free"
  retention_in_days   = 7
}

resource "azurerm_monitor_diagnostic_setting" "app_gw" {
  name                       = local.application_gateway_name
  target_resource_id         = azurerm_application_gateway.app_gw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.app_gw.id

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
    azurerm_application_gateway.app_gw
  ]
}
