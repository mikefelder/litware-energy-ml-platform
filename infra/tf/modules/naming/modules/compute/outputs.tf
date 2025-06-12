output "naming_rules" {
  description = "Naming rules for compute resources"
  value = {
    virtual_machine = {
      name        = substr(join("-", compact([join("-", var.prefixes), "vm", join("-", var.suffixes)])), 0, 64)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "vm", join("-", var.suffixes)])), 0, 64)
      dashes      = true
      slug        = "vm"
      min_length  = 1
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    virtual_machine_scale_set = {
      name        = substr(join("-", compact([join("-", var.prefixes), "vmss", join("-", var.suffixes)])), 0, 64)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "vmss", join("-", var.suffixes)])), 0, 64)
      dashes      = true
      slug        = "vmss"
      min_length  = 1
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
    }
    managed_disk = {
      name        = substr(join("-", compact([join("-", var.prefixes), "disk", join("-", var.suffixes)])), 0, 80)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "disk", join("-", var.suffixes)])), 0, 80)
      dashes      = true
      slug        = "disk"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
  }
}