
output "acr_uri" {
  value = "${azurerm_container_registry.example.login_server}"
}

output "acr_user" {
  value = "${azurerm_container_registry.example.admin_username}"
}

output "acr_password" {
  value = "${azurerm_container_registry.example.admin_password}"
  sensitive = true
}