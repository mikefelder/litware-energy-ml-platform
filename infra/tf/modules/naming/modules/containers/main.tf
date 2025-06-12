# Random string for unique naming
resource "random_string" "main" {
  count   = 1
  length  = 6
  special = false
  upper   = false
}