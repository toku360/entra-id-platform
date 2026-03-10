terraform {
  backend "azurerm" {
    resource_group_name  = "rg-entra-id-platform-tfstate"
    storage_account_name = "stentraidplatformtfstate"
    container_name       = "tfstate-prod"
    key                  = "prod.terraform.tfstate"
  }
}
