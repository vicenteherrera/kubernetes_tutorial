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

variable "node_count" {
  description = "Number of nodes for the Kubernetes cluster"
}

variable "vm_size" {
  description = "VM size for each node"
}

variable "os_disk_size_gb" {
  description = "VM disk size in Gb"
}