terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-backend"
    storage_account_name = "zoopzoop"
    container_name       = "meowgng1"
    key                  = "vnet-compute/prod.terraform.tfstate"
    use_azuread_auth     = true
  }
}
