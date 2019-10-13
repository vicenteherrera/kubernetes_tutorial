provider "azurerm" {
  # Version is optional, but a good practice to fix the version number for the one used when defining this file
  version = "=1.34.0"
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-k8s-resources"
  location = "${var.location}"
}

resource "azurerm_container_registry" "example" {
  name                     = "${var.prefix}Acr"
  resource_group_name      = "${azurerm_resource_group.example.name}"
  location                 = "${azurerm_resource_group.example.location}"
  sku                      = "Standard"
  admin_enabled            = true
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-k8s"
  location            = "${azurerm_resource_group.example.location}"  
  resource_group_name = "${azurerm_resource_group.example.name}"
  dns_prefix          = "${var.prefix}-k8s"

  agent_pool_profile {
    name            = "default"
    count           = 1     # Min nodes recommended for production
    vm_size         = "Standard_D2_v2"    # Hispter Shop requires min 6Gb Ram
    os_type         = "Linux"
    os_disk_size_gb = 40
  }

  service_principal {
    client_id     = "${var.client_id}" #"3d675fb6-28bc-4922-a267-0c0e97e305f6"
    client_secret = "${var.client_secret}" #69f5c2ec-87fa-4c61-9247-e31cc8a846d1"
  }
 
  tags = {
    Environment = "Production"
  }
}
