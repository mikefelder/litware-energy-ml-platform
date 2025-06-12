output "naming_rules" {
  description = "Naming rules for web resources"
  value = {
    app_service = {
      name        = substr(join("-", compact([join("-", var.prefixes), "app", join("-", var.suffixes)])), 0, 60)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "app", join("-", var.suffixes)])), 0, 60)
      dashes      = true
      slug        = "app"
      min_length  = 2
      max_length  = 60
      scope       = "global"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
    }
    app_service_plan = {
      name        = substr(join("-", compact([join("-", var.prefixes), "plan", join("-", var.suffixes)])), 0, 40)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "plan", join("-", var.suffixes)])), 0, 40)
      dashes      = true
      slug        = "plan"
      min_length  = 1
      max_length  = 40
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-]+$"
    }
    static_web_app = {
      name        = substr(join("-", compact([join("-", var.prefixes), "stapp", join("-", var.suffixes)])), 0, 60)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "stapp", join("-", var.suffixes)])), 0, 60)
      dashes      = true
      slug        = "stapp"
      min_length  = 2
      max_length  = 60
      scope       = "resourceGroup"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
    }
  }
}