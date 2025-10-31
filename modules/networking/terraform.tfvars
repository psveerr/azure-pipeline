resource_group_name = "rg-dev-network"
location            = "East US"
environment         = "dev"
vnet_address_space  = ["10.0.0.0/16"]

public_subnet_address_prefixes = [
  "10.0.1.0/24"
]
private_subnet_address_prefixes = [
  "10.0.2.0/24"
]

# SSH Rule
ssh_rule_name                       = "AllowSSH"
ssh_rule_priority                   = 100
ssh_rule_direction                  = "Inbound"
ssh_rule_access                     = "Allow"
ssh_rule_protocol                   = "Tcp"
ssh_source_port_range               = "*"
ssh_destination_port_range          = "22"
ssh_source_address_prefix           = "Internet"
ssh_destination_address_prefix      = "*"

# HTTP Rule
http_rule_name                      = "AllowHTTP"
http_rule_priority                  = 101
http_rule_direction                 = "Inbound"
http_rule_access                    = "Allow"
http_rule_protocol                  = "Tcp"
http_source_port_range              = "*"
http_destination_port_range         = "80"
http_source_address_prefix          = "Internet"
http_destination_address_prefix     = "*"
