resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.environment}-vm-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = var.nsg_id
}

resource "azurerm_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "${var.environment}-vm-${count.index}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }

  storage_os_disk {
    name              = "osdisk-${count.index}"
    caching           = var.os_disk_caching
    create_option     = "FromImage"
    managed_disk_type = var.os_disk_type
  }

  os_profile {
    computer_name  = "${var.environment}-vm-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = var.user_data_script
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
