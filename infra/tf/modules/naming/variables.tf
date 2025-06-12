variable "prefix" {
  description = "Prefix to be used with all resource names"
  type        = string
  default     = ""
}

variable "suffix" {
  description = "Suffix to be appended to all resource names"
  type        = list(string)
  default     = []
}

variable "unique-length" {
  description = "Length of the unique string to be generated"
  type        = number
  default     = 4
}

variable "unique-include-numbers" {
  description = "Include numbers in the unique string"
  type        = bool
  default     = true
}
