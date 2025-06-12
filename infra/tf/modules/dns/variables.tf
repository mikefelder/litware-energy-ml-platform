variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where DNS zones will be created"
}

variable "ai_services_vnet_id" {
  type        = string
  description = "ID of the AI services VNet to link with DNS zones"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}
