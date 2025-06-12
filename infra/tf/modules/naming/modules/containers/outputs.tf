output "naming_rules" {
  description = "Naming rules for container resources"
  value = {
    container_registry = {
      name        = substr(join("", compact([join("", var.prefixes), "cr", join("", var.suffixes)])), 0, 50)
      name_unique = substr(join("", compact([join("", var.prefixes), "cr", join("", var.suffixes), random_string.main[0].result])), 0, 50)
      dashes      = false
      slug        = "cr"
      min_length  = 5
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z0-9]+$"
    }
    kubernetes_cluster = {
      name        = substr(join("-", compact([join("-", var.prefixes), "aks", join("-", var.suffixes)])), 0, 63)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "aks", join("-", var.suffixes)])), 0, 63)
      dashes      = true
      slug        = "aks"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    container_instance = {
      name        = substr(join("-", compact([join("-", var.prefixes), "ci", join("-", var.suffixes)])), 0, 63)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "ci", join("-", var.suffixes)])), 0, 63)
      dashes      = true
      slug        = "ci"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
  }
}