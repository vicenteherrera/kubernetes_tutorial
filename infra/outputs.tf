output "id" {
  value = "${azurerm_kubernetes_cluster.example.id}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.example.kube_config_raw}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.example.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.example.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.example.kube_config.0.host}"
}

output "acr_uri" {
  value = "${azurerm_container_registry.example.login_server}"
}

output "acr_user" {
  value = "${azurerm_container_registry.example.admin_username}"
}

output "acr_password" {
  value = "${azurerm_container_registry.example.admin_password}"
}