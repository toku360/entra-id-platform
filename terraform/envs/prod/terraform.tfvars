resource_group_name = "rg-entra-id-platform-prod"
location            = "Japan East"

tags = {
  project = "entra-id-platform"
  env     = "prod"
  owner   = "toku360"
}

vnet_name     = "vnet-entra-id-platform-prod"
address_space = ["10.30.0.0/16"]

subnets = {
  subnet-lab = {
    address_prefixes = ["10.30.1.0/24"]
  }
}

nsg_name = "nsg-entra-id-platform-prod"

security_rules = {
  allow-ssh = {
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

identity_name = "id-entra-id-platform-prod"

role_assignments = {
  rg-reader = {
    role_definition_name = "Reader"
  }
}
