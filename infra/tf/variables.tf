variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "tenant_domain" {
  description = "The domain name of the Entra ID tenant"
  type        = string
}

variable "admin_email" {
  description = "Email address for admin notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type = object({
    Project     = string
    Environment = string
    Company     = string
    Owner       = string
    CostCenter  = string
  })
  default = {
    Project     = "AIML-Energy"
    Environment = "POC"
    Company     = "Litware Energy Co"
    Owner       = "AnalyticsTeam"
    CostCenter  = "EnergyPOC"
  }
}

# Naming module variables
variable "prefix" {
  type        = list(string)
  default     = []
  description = "Resource name prefix. Not recommended by Azure - use suffix instead."
}

variable "suffix" {
  type        = list(string)
  default     = ["litware", "poc"]
  description = "Resource name suffix for consistency. Use lowercase characters when possible."
}

variable "unique-seed" {
  description = "Custom value for the random characters to be used for uniqueness"
  type        = string
  default     = ""
}

variable "unique-length" {
  description = "Max length of the uniqueness suffix to be added"
  type        = number
  default     = 4
}

variable "unique-include-numbers" {
  description = "If you want to include numbers in the unique generation"
  type        = bool
  default     = true
}

# Storage account variables
variable "storage_account_kind" {
  description = "The kind of storage account to create"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_tier" {
  description = "The tier of storage account to create"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "The replication type for the storage account"
  type        = string
  default     = "LRS"
}

variable "enable_https_traffic_only" {
  description = "Forces HTTPS if enabled"
  type        = bool
  default     = true
}

variable "devops_project" {
  description = "Name of the Azure DevOps project for Data Factory integration"
  type        = string
  default     = "LitwareEnergyML"
}

# RBAC variables
variable "role_assignments" {
  description = "Map of role assignments to create"
  type = map(object({
    role_definition_name             = string
    principal_id                     = string
    skip_service_principal_aad_check = bool
  }))
  default = {}
}

variable "role_definition_ids" {
  description = "Map of role definition IDs"
  type        = map(string)
  default = {
    "Contributor" = "b24988ac-6180-42a0-ab88-20f7382dd24c"
    "Owner"       = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
    "Reader"      = "acdd72a7-3385-48ef-bd42-f606fba81ae7"
  }
}

# Azure AD variables
variable "test_users_count" {
  description = "Number of test users to create"
  type        = number
  default     = 3
}

variable "user_password_length" {
  description = "Length of generated passwords for test users"
  type        = number
  default     = 16
}

variable "user_password_special_chars" {
  description = "Special characters to use in test user passwords"
  type        = string
  default     = "!@#%&*"
}
