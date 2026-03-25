variable "resource_group_name" {
  description = "Resource Group name for dev environment"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name for dev environment"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for Virtual Network"
  type        = list(string)
}

variable "subnets" {
  description = "Subnet definitions for dev environment"
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "tags" {
  description = "Tags for Azure resources"
  type        = map(string)
}

variable "security_rules" {
  description = "Security rules for NSG"

  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "identity_name" {
  description = "User Assigned Managed Identity name for dev environment"
  type        = string
}

variable "role_assignments" {
  description = "Role assignments for the managed identity"
  type = map(object({
    role_definition_name = string
  }))
}



