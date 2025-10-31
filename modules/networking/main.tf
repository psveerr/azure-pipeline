resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}-vnet"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "public" {
  name                 = "${var.environment}-public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.public_subnet_address_prefixes
}

resource "azurerm_subnet" "private" {
  name                 = "${var.environment}-private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.private_subnet_address_prefixes
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.environment}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = var.ssh_rule_name
    priority                   = var.ssh_rule_priority
    direction                  = var.ssh_rule_direction
    access                     = var.ssh_rule_access
    protocol                   = var.ssh_rule_protocol
    source_port_range          = var.ssh_source_port_range
    destination_port_range     = var.ssh_destination_port_range
    source_address_prefix      = var.ssh_source_address_prefix
    destination_address_prefix = var.ssh_destination_address_prefix
  }

  security_rule {
    name                       = var.http_rule_name
    priority                   = var.http_rule_priority
    direction                  = var.http_rule_direction
    access                     = var.http_rule_access
    protocol                   = var.http_rule_protocol
    source_port_range          = var.http_source_port_range
    destination_port_range     = var.http_destination_port_range
    source_address_prefix      = var.http_source_address_prefix
    destination_address_prefix = var.http_destination_address_prefix
  }
}
