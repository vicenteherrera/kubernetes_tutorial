provider "azurerm" {
  version = "~> 1.34"
}

terraform {
  backend "azurerm" {
    storage_account_name  = "tstatesystest"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
  }
}



module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = "${var.prefix}-k8s-resources"
  location            = "${var.location}"
}

module "acr" {
  source              = "./modules/acr"
  prefix              = "${var.prefix}"
  location            = "${var.location}"
  resource_group_name = module.resource_group.name
}

module "aks" {
  source              = "./modules/aks"
  prefix              = "${var.prefix}"
  location            = "${var.location}"
  client_id           = "${var.client_id}"
  client_secret       = "${var.client_secret}"
  node_count          = "${var.node_count}"
  vm_size             = "${var.vm_size}"
  os_disk_size_gb     = "${var.os_disk_size_gb}"
  resource_group_name = module.resource_group.name
}

module "load_balancer" {
  source               = "./modules/load_balancer"
  public_ip_address_id = module.public_ip.id
  location             = "${var.location}"
  prefix               = "${var.prefix}"
  resource_group_name  = module.resource_group.name
}

module "public_ip" {
  source              = "./modules/public_ip"
  prefix              = "${var.prefix}"
  location            = "${var.location}"
  resource_group_name = module.resource_group.name
}
