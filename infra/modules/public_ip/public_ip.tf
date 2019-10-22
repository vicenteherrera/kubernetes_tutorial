resource "azurerm_public_ip" "example" {
  name                = "${var.prefix}-PublicIPForLB"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
  tags = {
    Environment = "Development"
    Creator = "Terraform"
  }
}