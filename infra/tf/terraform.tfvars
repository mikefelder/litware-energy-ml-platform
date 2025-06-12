# General configuration
location      = "eastus"
tenant_domain = "ibuyspy.net" # "litwareenergyco.onmicrosoft.com"
admin_email   = "a-ivega@ibuyspy.net" # This is your email address 

# Resource tags
tags = {
  Project     = "AIML-Energy"
  Environment = "POC"
  Company     = "Litware Energy Co"
  Owner       = "AnalyticsTeam"
  CostCenter  = "EnergyPOC"
}



# Naming convention configuration
prefix                 = "litware"
suffix                 = ["litware", "poc"]
unique-length          = 4
unique-include-numbers = true

# Storage account configuration
storage_account_kind             = "StorageV2"
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"
enable_https_traffic_only        = true

# User testing configuration
test_users_count            = 3
user_password_length        = 16
user_password_special_chars = "!@#%&*"
