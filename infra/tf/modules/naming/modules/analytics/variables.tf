variable "prefixes" {
  description = "Application prefix to apply to resources"
  type        = list(string)
  default     = []
}

variable "suffixes" {
  description = "Application suffix to apply to resources"
  type        = list(string)
  default     = []
}

variable "random_length" {
  description = "Length of random string"
  type        = number
  default     = 0
}

variable "separator" {
  description = "Separator between each elements"
  type        = string
  default     = "-"
}

variable "clean_input" {
  description = "Remove special characters from inputs"
  type        = bool
  default     = true
}

variable "regex_replace_chars" {
  description = "Regex to replace chars with empty string"
  type        = string
  default     = "/[^a-zA-Z0-9]/"
}

variable "name_length_restriction" {
  description = "Restrict length to a maximum value"
  type = object({
    length      = number
    clean_input = bool
  })
  default = null
}