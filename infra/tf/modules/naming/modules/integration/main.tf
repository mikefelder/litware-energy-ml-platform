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
  
  // Integration resource naming patterns following Azure Cloud Adoption Framework
  az = {
    eventgrid_domain = {
      name        = substr(join("-", compact([local.clean_prefix, "egd", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      name_unique = substr(join("-", compact([local.clean_prefix, "egd", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      dashes      = true
      slug        = "egd"
      min_length  = 3
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z0-9-]+$"
    }
    eventgrid_topic = {
      name        = substr(join("-", compact([local.clean_prefix, "egt", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      name_unique = substr(join("-", compact([local.clean_prefix, "egt", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      dashes      = true
      slug        = "egt"
      min_length  = 3
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z0-9-]+$"
    }
    eventhub_namespace = {
      name        = substr(join("-", compact([local.clean_prefix, "ehn", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      name_unique = substr(join("-", compact([local.clean_prefix, "ehn", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      dashes      = true
      slug        = "ehn"
      min_length  = 6
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    eventhub = {
      name        = substr(join("-", compact([local.clean_prefix, "evh", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      name_unique = substr(join("-", compact([local.clean_prefix, "evh", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      dashes      = true
      slug        = "evh"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    servicebus_namespace = {
      name        = substr(join("-", compact([local.clean_prefix, "sb", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      name_unique = substr(join("-", compact([local.clean_prefix, "sb", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      dashes      = true
      slug        = "sb"
      min_length  = 6
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    servicebus_queue = {
      name        = substr(join("-", compact([local.clean_prefix, "sbq", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      name_unique = substr(join("-", compact([local.clean_prefix, "sbq", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      dashes      = true
      slug        = "sbq"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    servicebus_topic = {
      name        = substr(join("-", compact([local.clean_prefix, "sbt", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      name_unique = substr(join("-", compact([local.clean_prefix, "sbt", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      dashes      = true
      slug        = "sbt"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
  }
}