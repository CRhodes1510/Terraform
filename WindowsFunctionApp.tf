resource "azurerm_windows_function_app" "func" {
  name                          = var.func_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.asp.id
  functions_extension_version   = "~4"
  https_only                    = false
  storage_account_name          = azurerm_storage_account.sa.name
  storage_uses_managed_identity = true

  identity {
    type = "SystemAssigned"
  }
  site_config {
  
  application_stack {
      dotnet_version = 6
    }
  }

  app_settings = {
    AzureWebJobsStorage                   = azurerm_storage_account.sa.primary_connection_string
    APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.appinsights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = "InstrumentationKey=${azurerm_application_insights.appinsights.instrumentation_key}"
    FUNCTIONS_EXTENSION_VERSION           = "~4"
    FUNCTIONS_WORKER_RUNTIME              = "dotnet"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE       = true
    WEBSITE_RUN_FROM_PACKAGE              = 1
  }
  lifecycle {
    ignore_changes = [
      tags,
      app_settings,
      site_config
    ]
  }
}