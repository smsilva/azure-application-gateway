variable "name" {
  type        = string
  description = "(Required) The name of the Application Gateway."
}

variable "resource_group" {
  description = "(Required) Application Gateway Resource Group"
  type = object({
    name     = string
    location = string
  })
}

variable "zones" {
  type        = list(string)
  description = "(Optional) A collection of availability zones to spread the Application Gateway over. They are also only supported for v2 SKUs"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags to assign to the API Management service."
  default     = {}
}

variable "sku_name" {
  type        = string
  description = "(Required) SKU Name"
  default     = "WAF_V2"
}

variable "sku_tier" {
  type        = string
  description = "(Required) SKU Tier"
  default     = "WAF_V2"
}

variable "public_ip_allocation_method" {
  type        = string
  description = "(Required) Public IP Allocation Method"
  default     = "Static"
}

variable "public_ip_sku" {
  type        = string
  description = "(Required) Public IP SKU"
  default     = "Standard"
}

variable "autoscale_configuration" {
  description = "(Optional) An autoscale configuration object. Accepted values for min_capacity are in the range 0 to 100. Accepted values for max_capacity are in the range 2 to 125."
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = {
    min_capacity = 1
    max_capacity = 5
  }
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the Subnet which the Application Gateway should be connected to."
}

variable "public_ip_domain_name_label" {
  type        = string
  description = "(Optional) The Public IP DNS name label."
  default     = null
}
