resource "azurerm_lb" "example" {
  name                = "${var.prefix}-LoadBalancer"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${var.public_ip_address_id}"
  }
  tags = {
    Environment = "Development"
    Creator = "Terraform"
  }
}