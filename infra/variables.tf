variable "prefix" {
  description = "A prefix used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "client_id" {
  description = "Service Principal client id"
}
variable "client_secret" {
  description = "Service Principal client secret (password)"
}