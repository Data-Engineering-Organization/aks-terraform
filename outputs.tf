output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "get_credentials_command" {
  value = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "appgw_public_ip" {
  value = azurerm_public_ip.appgw.ip_address
}

output "dns_name_servers" {
  description = "Set these as the name servers at your domain registrar"
  value       = azurerm_dns_zone.zone.name_servers
}
