output "naming_rules" {
  description = "Naming rules for storage resources"
  value = {
    storage_account = {
      name        = substr(join("", compact([join("", var.prefixes), "st", join("", var.suffixes)])), 0, 24)
      name_unique = substr(join("", compact([join("", var.prefixes), "st", join("", var.suffixes), random_string.main[0].result])), 0, 24)
      dashes      = false
      slug        = "st"
      min_length  = 3
      max_length  = 24
      scope       = "global"
      regex       = "^[a-z0-9]+$"
    }
    container = {
      name        = substr(join("-", compact([join("-", var.prefixes), "ct", join("-", var.suffixes)])), 0, 63)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "ct", join("-", var.suffixes)])), 0, 63)
      dashes      = true
      slug        = "ct"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
    }
    file_share = {
      name        = substr(join("-", compact([join("-", var.prefixes), "fs", join("-", var.suffixes)])), 0, 63)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "fs", join("-", var.suffixes)])), 0, 63)
      dashes      = true
      slug        = "fs"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
    }
    queue = {
      name        = substr(join("-", compact([join("-", var.prefixes), "q", join("-", var.suffixes)])), 0, 63)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "q", join("-", var.suffixes)])), 0, 63)
      dashes      = true
      slug        = "q"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
    }
    table = {
      name        = substr(join("", compact([join("", var.prefixes), "tbl", join("", var.suffixes)])), 0, 63)
      name_unique = substr(join("", compact([join("", var.prefixes), "tbl", join("", var.suffixes)])), 0, 63)
      dashes      = false
      slug        = "tbl"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z][a-zA-Z0-9]{2,62}$"
    }
  }
}