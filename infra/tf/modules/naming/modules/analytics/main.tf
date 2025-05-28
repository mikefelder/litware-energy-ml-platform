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
  
  // Analytics resource naming patterns following Azure Cloud Adoption Framework
  az = {
    application_insights = {
      name        = substr(join("-", compact([local.clean_prefix, "ai", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      name_unique = substr(join("-", compact([local.clean_prefix, "ai", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      dashes      = true
      slug        = "ai"
      min_length  = 1
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    },
    data_factory = {
      name        = substr(join("-", compact([local.clean_prefix, "adf", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 63))
      name_unique = substr(join("-", compact([local.clean_prefix, "adf", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 63))
      dashes      = true
      slug        = "adf"
      min_length  = 3
      max_length  = 63
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    },
    machine_learning_workspace = {
      name        = substr(join("-", compact([local.clean_prefix, "mlw", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      name_unique = substr(join("-", compact([local.clean_prefix, "mlw", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      dashes      = true
      slug        = "mlw"
      min_length  = 2
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[^<>*%:?\\+\\/]+[^<>*%:.?\\+\\/]$"
    },
    databricks_workspace = {
      name        = substr(join("-", compact([local.clean_prefix, "dbw", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 30))
      name_unique = substr(join("-", compact([local.clean_prefix, "dbw", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 30))
      dashes      = true
      slug        = "dbw"
      min_length  = 3
      max_length  = 30
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-_]+$"
    },
    synapse_workspace = {
      name        = substr(join("-", compact([local.clean_prefix, "syn", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      name_unique = substr(join("-", compact([local.clean_prefix, "syn", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 50))
      dashes      = true
      slug        = "syn"
      min_length  = 1
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    },
    analysis_services_server = {
      name        = substr(join("", compact([local.clean_prefix, "as", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 63))
      name_unique = substr(join("", compact([local.clean_prefix, "as", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 63))
      dashes      = false
      slug        = "as"
      min_length  = 3
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-z][a-z0-9]+$"
    },
    log_analytics_workspace = {
      name        = substr(join("", compact([local.clean_prefix, "log", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 63))
      name_unique = substr(join("", compact([local.clean_prefix, "log", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 63))
      dashes      = false
      slug        = "log"
      min_length  = 4
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    monitor_action_group = {
      name        = substr(join("", compact([local.clean_prefix, "mag", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      name_unique = substr(join("", compact([local.clean_prefix, "mag", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 260))
      dashes      = false
      slug        = "mag"
      min_length  = 1
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    fabric_capacity = {
      name        = substr(join("", compact([local.clean_prefix, "fab", local.clean_suffix])), 0, coalesce(try(var.name_length_restriction.length, null), 63))
      name_unique = substr(join("", compact([local.clean_prefix, "fab", local.clean_suffix, local.random_string])), 0, coalesce(try(var.name_length_restriction.length, null), 63))
      dashes      = false
      slug        = "fab"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
  }
}