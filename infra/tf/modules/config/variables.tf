variable "environment" {
  type        = string
  description = "Environment name (e.g., prod, dev, staging)"
  default     = "prod"
}

variable "prefix" {
  type        = string
  description = "Prefix to use for resource naming"
  default     = "litware"
}

variable "company_name" {
  type        = string
  description = "Company name for tagging"
  default     = "Litware Energy Co"
}

variable "cost_center" {
  type        = string
  description = "Cost center for tagging"
  default     = "EnergyPOC"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging"
  default     = "AIML-Energy"
}

variable "owner" {
  type        = string
  description = "Owner team for tagging"
  default     = "AnalyticsTeam"
}
