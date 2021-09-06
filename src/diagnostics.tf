resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "centralus"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "acctest-01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Free"
  retention_in_days   = 7
}

resource "azurerm_monitor_diagnostic_setting" "app-gw-aks" {
  name                       = var.name
  target_resource_id         = azurerm_application_gateway.app_gw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

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
