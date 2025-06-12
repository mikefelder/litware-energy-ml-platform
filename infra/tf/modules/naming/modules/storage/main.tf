locals {
  # No local variables needed for this module
  # All naming rules are defined in the outputs
}

# Random string for unique naming
resource "random_string" "main" {
  count   = 1
  length  = 6
  special = false
  upper   = false
}