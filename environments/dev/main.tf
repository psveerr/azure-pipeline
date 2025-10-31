provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

module "network" {
  source                     = "../../modules/networking"
  environment                = var.environment
  location                   = var.location
  resource_group_name        = var.resource_group_name
  public_subnet_address_prefixes  = var.public_subnet_address_prefixes
  private_subnet_address_prefixes = var.private_subnet_address_prefixes
}

module "nginx_app" {
  source      = "../../modules/nginx"
  environment = var.environment
}

ssl_certificate {
  name     = var.ssl_certificate_name
  data     = base64encode(file("${path.module}/${var.cert_file_path}"))
  password = var.cert_pfx_password
}

http_listener {
  name                            = var.http_listener_name
  frontend_ip_configuration_name  = "publicIp"
  frontend_port_name              = "frontendPortHttps"
  protocol                        = "Https"
  ssl_certificate_name            = var.ssl_certificate_name
  host_name                       = var.host_name
}

module "compute" {
  source              = "../../modules/compute"
  environment         = var.environment
  location            = module.network.location
  resource_group_name = module.network.resource_group_name
  private_subnet_id   = module.network.private_subnet_id
  nsg_id              = module.network.nsg_id
  vm_size             = var.vm_size
  admin_password      = var.admin_password
  vm_count            = var.vm_count
  user_data_script    = module.nginx_app.user_data_script
}

module "loadbalancer" {
  source              = "../../modules/loadbalancer"
  environment         = var.environment
  location            = module.network.location
  resource_group_name = module.network.resource_group_name
  public_subnet_id    = module.network.public_subnet_id
  backend_ip_addresses = module.compute.private_ips
}
