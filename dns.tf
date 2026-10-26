# ---------------------------------------------------------------
# Azure DNS: aom-service.com -> Application Gateway public IP
# After apply, copy the name servers (output) to your domain registrar.
# ---------------------------------------------------------------
resource "azurerm_dns_zone" "zone" {
  name                = var.domain_name
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_dns_a_record" "root" {
  name                = "@"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.appgw.id
}
