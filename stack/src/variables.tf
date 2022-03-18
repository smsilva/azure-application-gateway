variable "name" {
  type    = string
  default = "app-gw"
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "resource_group_name" {
  type    = string
  default = ""
}

variable "subnet" {}
