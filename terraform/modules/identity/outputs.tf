output "identity_id" {
  description = "Managed Identity resource ID"
  value       = azurerm_user_assigned_identity.this.id
}

output "identity_name" {
  description = "Managed Identity name"
  value       = azurerm_user_assigned_identity.this.name
}

output "principal_id" {
  description = "Managed Identity principal ID"
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Managed Identity client ID"
  value       = azurerm_user_assigned_identity.this.client_id
}
