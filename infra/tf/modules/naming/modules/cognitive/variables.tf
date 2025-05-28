variable "name" {
  type        = string
  description = "Base name for cognitive resources"
  default     = ""
}

variable "prefixes" {
  type        = list(string)
  description = "List of prefixes to use for cognitive resources"
  default     = []
}

variable "suffixes" {
  type        = list(string)
  description = "List of suffixes to append to cognitive resources"
  default     = []
}

variable "delimiter" {
  type        = string
  description = "Delimiter to use between name segments"
  default     = "-"
}

variable "random_length" {
  type        = number
  description = "Length of random string to use for uniqueness"
  default     = 4
}

variable "clean_input" {
  type        = bool
  description = "Whether to clean input strings of special characters"
  default     = true
}

variable "regex_replace_chars" {
  type        = string
  description = "Regex to replace chars with empty string"
  default     = "/[^a-zA-Z0-9-]/"
}
