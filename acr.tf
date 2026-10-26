# ---------------------------------------------------------------
# Container registry for the pay / login / ardor images
# ---------------------------------------------------------------
resource "random_string" "acr_suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr${random_string.acr_suffix.result}" # globally unique, letters/numbers only
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags
}

# Allow AKS nodes to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}
