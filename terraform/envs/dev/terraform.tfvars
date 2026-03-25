resource_group_name = "rg-entra-id-platform-dev"
location            = "Japan East"

vnet_name          = "vnet-entra-id-platform-dev"
vnet_address_space = ["10.10.0.0/16"]

subnets = {
  subnet-lab = {
    address_prefixes = ["10.10.1.0/24"]
  }
}

nsg_name = "nsg-entra-id-platform-dev"

tags = {
  project = "entra-id-platform"
  env     = "dev"
  owner   = "toku360"
}

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

identity_name = "id-entra-id-platform-dev"

role_assignments = {
  rg-reader = {
    role_definition_name = "Reader"
  }
}


