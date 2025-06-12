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

  // Cognitive services resource naming patterns following Azure Cloud Adoption Framework
  az = {
    cognitive_account = {
      name        = substr(join("-", compact([local.clean_prefix, "cog", local.clean_suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.clean_prefix, "cog", local.clean_suffix, local.random_string])), 0, 64)
      dashes      = true
      slug        = "cog"
      min_length  = 2
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    openai_service = {
      name        = substr(join("-", compact([local.clean_prefix, "oai", local.clean_suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.clean_prefix, "oai", local.clean_suffix, local.random_string])), 0, 64)
      dashes      = true
      slug        = "oai"
      min_length  = 2
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    document_intelligence = {
      name        = substr(join("-", compact([local.clean_prefix, "doci", local.clean_suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.clean_prefix, "doci", local.clean_suffix, local.random_string])), 0, 64)
      dashes      = true
      slug        = "doci"
      min_length  = 2
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
  }
}
