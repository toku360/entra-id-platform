output "nsg_id" {
  description = "NSG ID"
  value       = azurerm_network_security_group.this.id
}

output "nsg_name" {
  description = "NSG name"
  value       = azurerm_network_security_group.this.name
}


