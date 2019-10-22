resource "azurerm_container_registry" "example" {
  name                     = "${var.prefix}Acr"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  sku                      = "Standard"
  admin_enabled            = true
  tags = {
    Environment = "Development"
    Creator = "Terraform"
  }
}