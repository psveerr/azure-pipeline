vm_count            = 2
environment         = "dev"
location            = "East US"
resource_group_name = "rg-dev-compute"
private_subnet_id   = "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/privatesubnet"
nsg_id              = "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg-name"
vm_size             = "Standard_B1s"
admin_password      = "P@ssw0rd12345!"
user_data_script    = "#!/bin/bash\necho Hello World"

os_publisher        = "Canonical"
os_offer            = "UbuntuServer"
os_sku              = "18.04-LTS"
os_version          = "latest"

os_disk_type        = "Standard_LRS"
os_disk_caching     = "ReadWrite"

admin_username      = "adminuser"
