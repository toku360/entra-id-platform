output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Subnet IDs"
  value = {
    for k, v in azurerm_subnet.this : k => v.id
  }
}

output "subnet_names" {
  description = "Subnet names"
  value = {
    for k, v in azurerm_subnet.this : k => v.name
  }
}
