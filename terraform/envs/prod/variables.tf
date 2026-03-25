variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

variable "vnet_name" { type = string }
variable "address_space" { type = list(string) }

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "nsg_name" { type = string }

variable "security_rules" {
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

variable "identity_name" { type = string }

variable "role_assignments" {
  type = map(object({
    role_definition_name = string
  }))
}


