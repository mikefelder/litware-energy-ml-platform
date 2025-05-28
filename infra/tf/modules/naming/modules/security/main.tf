resource "random_string" "main" {
  count   = var.random_length > 0 ? 1 : 0
  length  = var.random_length
  special = false
  upper   = false
}

locals {
  clean_prefix   = var.clean_input ? replace(join(var.delimiter, var.prefixes), var.regex_replace_chars, "") : join(var.delimiter, var.prefixes)
  clean_suffix   = var.clean_input ? replace(join(var.delimiter, var.suffixes), var.regex_replace_chars, "") : join(var.delimiter, var.suffixes)
  random_string  = var.random_length > 0 ? random_string.main[0].result : ""

  // Security resource naming patterns
  az = {
    application_security_group = {
      name        = substr(join("-", compact([local.clean_prefix, "asg", local.clean_suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.clean_prefix, "asg", local.clean_suffix, local.random_string])), 0, 80)
      dashes      = true
      slug        = "asg"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    managed_identity = {
      name        = substr(join("-", compact([local.clean_prefix, "id", local.clean_suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.clean_prefix, "id", local.clean_suffix, local.random_string])), 0, 128)
      dashes      = true
      slug        = "id"
      min_length  = 3
      max_length  = 128
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    key_vault = {
      name        = substr(join("-", compact([local.clean_prefix, "kv", local.clean_suffix])), 0, 24)
      name_unique = substr(join("-", compact([local.clean_prefix, "kv", local.clean_suffix, local.random_string])), 0, 24)
      dashes      = true
      slug        = "kv"
      min_length  = 3
      max_length  = 24
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
  }
}