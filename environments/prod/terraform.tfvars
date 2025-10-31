environment     = "prod"
location        = "East US"
resource_group_name = "rg-prod-app"

public_subnet_address_prefixes = [
  "10.0.1.0/24"
]
private_subnet_address_prefixes = [
  "10.0.2.0/24"
]

vm_size         = "Standard_DS2_v2"
admin_password  = "TfSecureP@ssw0rd!"
vm_count        = 3
