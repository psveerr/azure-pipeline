subscription_id = "cd7ce892-0134-491f-81b8-d29b153b08b3"
environment     = "dev"
location        = "East US"
resource_group_name = "rg-dev-app-01"

public_subnet_address_prefixes = [
  "10.0.1.0/24"
]
private_subnet_address_prefixes = [
  "10.0.2.0/24"
]

vm_size         = "Standard_B2s"
admin_password  = "TfSecureP@ssw0rd!"
vm_count        = 2

ssl_certificate_name = "pfx-cert"
cert_file_path       = "certs/site-cert.pfx"
cert_pfx_password    = "CertP@ssw0rd!"
http_listener_name   = "https-listener"
host_name            = "www.example.com"
