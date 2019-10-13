provider "azurerm" {
  # Version is optional, but a good practice to fix the version number for the one used when defining this file
  version = "~> 1.34"
}

module "resource-group" {
  source = "./modules/resource-group"
  # prefix ="${var.prefix}"
  resource_group_name = "${var.prefix}-k8s-resources"
  location = "${var.location}"
}

module "acr" {
  source = "./modules/acr"
  prefix ="${var.prefix}"
  location = "${var.location}"
  #resource_group_name = "${module.resource-group.resource_group_name}"
  #resource_group_name = "${var.prefix}-k8s-resources"
  resource_group_name = module.resource-group.name
}

module "aks" {
  source = "./modules/aks"
  prefix ="${var.prefix}"
  location = "${var.location}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  # resource_group_name = "${var.prefix}-k8s-resources"
  resource_group_name = module.resource-group.name
}

