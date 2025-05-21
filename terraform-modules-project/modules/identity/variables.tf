//TODO: Do we need this module? Move to the root var module?
variable "tenant_domain" {
  description = "The domain name of the Entra ID tenant"
  type        = string
}

variable "user_count" {
  description = "Number of ML users to create"
  type        = number
  default     = 3
}

variable "team_group_name" {
  description = "Name of the ML team group"
  type        = string
  default     = "Litware-AIML-Team"
}