environment               = "prod"
location                  = "West US 2"
resource_group_name       = "rg-prod-appgw"
public_subnet_id          = "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/appgw-subnet"
backend_ip_addresses      = ["10.0.2.4", "10.0.2.5"]

# Public IP
public_ip_allocation_method = "Static"
public_ip_sku               = "Standard"

# Application Gateway SKU
app_gateway_sku_name        = "Standard_v2"
app_gateway_sku_tier        = "Standard_v2"
app_gateway_capacity        = 2

# Frontend Port
frontend_port_http_name     = "http-80"
frontend_port_http_port     = 80

# Backend Pool
backend_pool_name           = "web-servers-pool"

# Backend HTTP Settings
http_settings_name          = "http-settings-80"
cookie_based_affinity       = "Disabled"
backend_http_port           = 8080
backend_http_protocol       = "Http"
request_timeout             = 90
backend_host_name           = "127.0.0.1"

# HTTP Listener
http_listener_name          = "inbound-http-listener"
http_listener_protocol      = "Http"

# Routing Rule
routing_rule_name           = "path-basic-rule"
routing_rule_type           = "Basic"
routing_rule_priority       = 100

# Probe
probe_name                  = "web-health-probe"
probe_protocol              = "Http"
probe_host                  = "127.0.0.1"
probe_path                  = "/health"
probe_interval              = 45
probe_timeout               = 45
probe_unhealthy_threshold   = 3
