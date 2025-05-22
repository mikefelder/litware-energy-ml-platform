variable "prefix" {
  description = "Prefix to be used in all resource names"
  type        = string
  default     = "litware"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {
    environment = "staging"
    project     = "litware-energy-ml"
    managedBy   = "terraform"
  }
}
