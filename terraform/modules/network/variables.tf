variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
}

variable "subnets" {
  description = "Subnet definitions"
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
