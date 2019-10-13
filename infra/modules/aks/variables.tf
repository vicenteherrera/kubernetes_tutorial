variable "prefix" {
  description = "A prefix used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "resource_group_name" {
  description = "Resource Group Name"
}

variable "client_id" {
  description = "Service Principal client id"
}

variable "client_secret" {
  description = "Service Principal client secret (password)"
}