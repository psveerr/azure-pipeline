resource "azurerm_public_ip" "app_gateway_ip" {
  name                = "${var.environment}-app-gateway-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = "${var.environment}-app-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.app_gateway_sku_name
    tier     = var.app_gateway_sku_tier
    capacity = var.app_gateway_capacity
  }

  gateway_ip_configuration {
    name      = "default-config"
    subnet_id = var.public_subnet_id
  }

  frontend_port {
    name = var.frontend_port_http_name
    port = var.frontend_port_http_port
  }

  frontend_ip_configuration {
    name                 = "default-frontend-ip"
    public_ip_address_id = azurerm_public_ip.app_gateway_ip.id
  }

  backend_address_pool {
    name         = var.backend_pool_name
    ip_addresses = var.backend_ip_addresses
  }

  backend_http_settings {
    name                    = var.http_settings_name
    cookie_based_affinity   = var.cookie_based_affinity
    port                    = var.backend_http_port
    protocol                = var.backend_http_protocol
    request_timeout         = var.request_timeout
    probe_name              = var.probe_name
    host_name               = var.backend_host_name
  }

  http_listener {
    name                           = var.http_listener_name
    frontend_ip_configuration_name = "default-frontend-ip"
    frontend_port_name             = var.frontend_port_http_name
    protocol                       = var.http_listener_protocol
  }

  request_routing_rule {
    name                       = var.routing_rule_name
    rule_type                  = var.routing_rule_type
    http_listener_name         = var.http_listener_name
    backend_address_pool_name  = var.backend_pool_name
    backend_http_settings_name = var.http_settings_name
    priority                   = var.routing_rule_priority
  }

  probe {
    name                = var.probe_name
    protocol            = var.probe_protocol
    host                = var.probe_host
    path                = var.probe_path
    interval            = var.probe_interval
    timeout             = var.probe_timeout
    unhealthy_threshold = var.probe_unhealthy_threshold
  }
}
