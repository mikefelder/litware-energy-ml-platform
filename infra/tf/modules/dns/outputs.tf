# Output the Private DNS Zone IDs for use in other modules
output "private_dns_zone_ids" {
  value = {
    cognitive_services = azurerm_private_dns_zone.cognitive_services.id
    search            = azurerm_private_dns_zone.search.id
    blob              = azurerm_private_dns_zone.blob.id
    file              = azurerm_private_dns_zone.file.id
    table             = azurerm_private_dns_zone.table.id
    queue             = azurerm_private_dns_zone.queue.id
    dfs               = azurerm_private_dns_zone.dfs.id
  }
  description = "Map of Private DNS Zone IDs"
}
