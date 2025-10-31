terraform {
  backend "azurerm" {
    resource_group_name  = "veer-rg"
    storage_account_name = "zoopzoop"
    container_name       = "meowgng"
    key                  = "vnet-compute/prod.terraform.tfstate"
    use_azuread_auth     = true
  }
}
