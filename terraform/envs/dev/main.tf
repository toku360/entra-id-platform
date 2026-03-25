
module "resource_group" {
  source   = "../../modules/resource-group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "../../modules/network"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnets             = var.subnets
  tags                = var.tags
}

module "security" {
  source = "../../modules/security"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  nsg_name = var.nsg_name

  subnet_ids = module.network.subnet_ids

  security_rules = var.security_rules

  tags = var.tags
}

module "identity" {
  source = "../../modules/identity"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  identity_name       = var.identity_name
  scope               = module.resource_group.id
  role_assignments    = var.role_assignments
  tags                = var.tags
}



