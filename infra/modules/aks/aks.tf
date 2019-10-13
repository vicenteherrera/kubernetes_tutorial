resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-k8s"
  location            = "${var.location}"  
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.prefix}-k8s"

  agent_pool_profile {
    name            = "default"
    count           = 1                   # Min 3 nodes recommended for production
    vm_size         = "Standard_D2_v2"    # Hipster Shop requires min 6 Gb Ram
    os_type         = "Linux"
    os_disk_size_gb = 40                  # Hipster Shop requires min 32 Gb disk
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

}
