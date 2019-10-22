variable "prefix" {
  description = "A prefix used for all resources in this example"
  type = string
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  type = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type = string
}
