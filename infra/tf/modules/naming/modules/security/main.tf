resource "random_string" "main" {
  count   = var.random_length > 0 ? 1 : 0
  length  = var.random_length
  special = false
  upper   = false
}

locals {
  clean_prefix   = var.clean_input ? replace(join(var.separator, var.prefixes), var.regex_replace_chars, "") : join(var.separator, var.prefixes)
  clean_suffix   = var.clean_input ? replace(join(var.separator, var.suffixes), var.regex_replace_chars, "") : join(var.separator, var.suffixes)
  random_string  = var.random_length > 0 ? random_string.main[0].result : ""
  
  // Security resource naming patterns following Azure Cloud Adoption Framework
  az = {
    key_vault = {
      name        = substr(join("-", compact([local.clean_prefix, "kv", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 24))
      name_unique = substr(join("-", compact([local.clean_prefix, "kv", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 24))
      dashes      = true
      slug        = "kv"
      min_length  = 3
      max_length  = 24
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    key_vault_key = {
      name        = substr(join("-", compact([local.clean_prefix, "kvk", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 255))
      name_unique = substr(join("-", compact([local.clean_prefix, "kvk", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 255))
      dashes      = true
      slug        = "kvk"
      min_length  = 1
      max_length  = 255
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
    }
    key_vault_secret = {
      name        = substr(join("-", compact([local.clean_prefix, "kvs", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 127))
      name_unique = substr(join("-", compact([local.clean_prefix, "kvs", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 127))
      dashes      = true
      slug        = "kvs"
      min_length  = 1
      max_length  = 127
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
    }
    key_vault_certificate = {
      name        = substr(join("-", compact([local.clean_prefix, "kvc", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 127))
      name_unique = substr(join("-", compact([local.clean_prefix, "kvc", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 127))
      dashes      = true
      slug        = "kvc"
      min_length  = 1
      max_length  = 127
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
    }
    disk_encryption_set = {
      name        = substr(join("-", compact([local.clean_prefix, "des", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 80))
      name_unique = substr(join("-", compact([local.clean_prefix, "des", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 80))
      dashes      = true
      slug        = "des"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9_-]+$"
    }
    application_security_group = {
      name        = substr(join("-", compact([local.clean_prefix, "asg", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 80))
      name_unique = substr(join("-", compact([local.clean_prefix, "asg", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 80))
      dashes      = true
      slug        = "asg"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
    }
  }
}