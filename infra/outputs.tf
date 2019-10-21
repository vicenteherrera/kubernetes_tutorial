
output "resource_group_name" {
  value = "${module.resource-group.name}"
}

output "acr_uri" {
  value = "${module.acr.acr_uri}"
}

output "acr_user" {
  value = "${module.acr.acr_user}"
}

output "acr_password" {
  value     = "${module.acr.acr_password}"
  sensitive = true
}

output "id" {
  value = "${module.aks.id}"
}

output "kube_config" {
  value     = "${module.aks.kube_config}"
  sensitive = true
}

output "client_key" {
  value     = "${module.aks.client_key}"
  sensitive = true
}

output "client_certificate" {
  value     = "${module.aks.client_certificate}"
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = "${module.aks.cluster_ca_certificate}"
  sensitive = true
}

output "host" {
  value = "${module.aks.host}"
}