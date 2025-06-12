output "naming_rules" {
  description = "Naming rules for database resources"
  value = {
    sql_server = {
      name        = substr(join("-", compact([join("-", var.prefixes), "sql", join("-", var.suffixes)])), 0, 63)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "sql", join("-", var.suffixes)])), 0, 63)
      dashes      = true
      slug        = "sql"
      min_length  = 1
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
    }
    sql_database = {
      name        = substr(join("-", compact([join("-", var.prefixes), "sqldb", join("-", var.suffixes)])), 0, 128)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "sqldb", join("-", var.suffixes)])), 0, 128)
      dashes      = true
      slug        = "sqldb"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
    }
    cosmos_db = {
      name        = substr(join("-", compact([join("-", var.prefixes), "cosmos", join("-", var.suffixes)])), 0, 63)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "cosmos", join("-", var.suffixes)])), 0, 63)
      dashes      = true
      slug        = "cosmos"
      min_length  = 1
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
    }
  }
}