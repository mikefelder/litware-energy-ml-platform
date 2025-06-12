output "naming_rules" {
  description = "Naming rules for networking resources"
  value = {
    virtual_network = {
      name        = substr(join("-", compact([join("-", var.prefixes), "vnet", join("-", var.suffixes)])), 0, 64)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "vnet", join("-", var.suffixes)])), 0, 64)
      dashes      = true
      slug        = "vnet"
      min_length  = 2
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    subnet = {
      name        = substr(join("-", compact([join("-", var.prefixes), "snet", join("-", var.suffixes)])), 0, 80)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "snet", join("-", var.suffixes)])), 0, 80)
      dashes      = true
      slug        = "snet"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    network_security_group = {
      name        = substr(join("-", compact([join("-", var.prefixes), "nsg", join("-", var.suffixes)])), 0, 80)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "nsg", join("-", var.suffixes)])), 0, 80)
      dashes      = true
      slug        = "nsg"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    public_ip = {
      name        = substr(join("-", compact([join("-", var.prefixes), "pip", join("-", var.suffixes)])), 0, 80)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "pip", join("-", var.suffixes)])), 0, 80)
      dashes      = true
      slug        = "pip"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
    private_endpoint = {
      name        = substr(join("-", compact([join("-", var.prefixes), "pe", join("-", var.suffixes)])), 0, 80)
      name_unique = substr(join("-", compact([join("-", var.prefixes), "pe", join("-", var.suffixes)])), 0, 80)
      dashes      = true
      slug        = "pe"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
    }
  }
}