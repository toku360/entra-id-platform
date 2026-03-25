variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "identity_name" { type = string }

variable "scope" {
  type    = string
  default = null
}

variable "role_assignments" {
  type = map(object({
    role_definition_name = string
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
