# ---------------------------------------------------------------
# Application Gateway
#   Front end (FE) = Public IP    <- users / DNS
#   Back end  (BE) = Private IP   -> internal LB of ingress controller
# ---------------------------------------------------------------
resource "azurerm_public_ip" "appgw" {
  name                = "${var.prefix}-appgw-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

locals {
  gw_ip_config_name   = "gateway-ip-config"
  frontend_port_name  = "port-80"
  frontend_ip_name    = "public-frontend"
  backend_pool_name   = "aks-ingress-pool"
  backend_setting     = "aks-ingress-http-settings"
  listener_name       = "http-listener"
  routing_rule_name   = "route-to-aks"
  probe_name          = "ingress-health-probe"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "${var.prefix}-appgw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 3
  }

  gateway_ip_configuration {
    name      = local.gw_ip_config_name
    subnet_id = azurerm_subnet.appgw.id
  }

  # FE: public side
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  # BE: private IP of the internal load balancer (created by Kubernetes)
  backend_address_pool {
    name         = local.backend_pool_name
    ip_addresses = [var.ingress_lb_private_ip]
  }

  # nginx answers on /healthz for any host
  probe {
    name                = local.probe_name
    protocol            = "Http"
    host                = var.domain_name
    path                = "/healthz"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3

    match {
      status_code = ["200-399"]
    }
  }

  # Forward the original domain as Host header so the Ingress host rule matches
  backend_http_settings {
    name                  = local.backend_setting
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    host_name             = var.domain_name
    probe_name            = local.probe_name
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.routing_rule_name
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_pool_name
    backend_http_settings_name = local.backend_setting
  }
}
