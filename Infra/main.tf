

resource "azurerm_resource_group" "rg_hackathon" {
  name     = "node_app"
  location = "westus2"
}

resource "azurerm_kubernetes_cluster" "hackathon_aks" {
  name                = "hackathon-aks"
  location            = azurerm_resource_group.rg_hackathon.location
  resource_group_name = azurerm_resource_group.rg_hackathon.name
  dns_prefix          = "hackathon-k8s"
  kubernetes_version  = "1.26.3"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  role_based_access_control_enabled = true


  tags = {
    environment = "Hackathon"
  }
}


resource "azurerm_container_registry" "hackathon_acr" {
  name                = "containerRegistry1"
  resource_group_name = azurerm_resource_group.rg_hackathon.name
  location            = azurerm_resource_group.rg_hackathon.location
  sku                 = "Premium"
  admin_enabled       = false
}

# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "kubweb_to_acr" {
  scope                = azurerm_container_registry.hackathon_acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.hackathon_aks.kubelet_identity[0].object_id
}