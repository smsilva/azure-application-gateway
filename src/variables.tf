variable "platform_instance_name" {
  type        = string
  description = "(Required) Platform Instance Name"
}

variable "name" {
  type        = string
  description = "(Required) The name of the Application Gateway."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group."
}

variable "location" {
  type        = string
  description = "(Required) The location of the resources."
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
  description = "(Required) The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2."
  default     = "Standard_Small"
}

variable "sku_tier" {
  type        = string
  description = "(Required) The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2."
  default     = "Standard"
}

variable "sku_capacity" {
  type        = string
  description = "(Optional if autoscale_configuration is set) The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU."
  default     = 0
}

variable "autoscale_configuration" {
  type = object({
    min_capacity = number
    max_capacity = number
  })
  description = "(Optional) An autoscale configuration object. Accepted values for min_capacity are in the range 0 to 100. Accepted values for max_capacity are in the range 2 to 125."
  default = {
    min_capacity = 2
    max_capacity = 10
  }
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the Subnet which the Application Gateway should be connected to."
}

variable "firewall_policy_id" {
  type        = string
  description = "(Optional) The ID of the Web Application Firewall Policy."
  default     = null
}

variable "public_ip_domain_name_label" {
  type        = string
  description = "(Optional) The Public IP DNS name label."
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "(Required) The ID of the Log Analytics Workspace which the Application Gateway should send data to."
}
