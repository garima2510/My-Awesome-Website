output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "function_app_name" {
  value = azurerm_windows_function_app.az_afa.name
}