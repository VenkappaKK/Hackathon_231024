terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  cloud { 
    organization = "hackathon-learnvk" 
    workspaces { 
      name = "hackathon-learn-azure" 
    } 
  } 
  
}




provider "azurerm" {
  features {}

  subscription_id   = "90de0c98-2d25-4094-a834-32b29fdf8003"
  tenant_id         = "0b889ca3-c111-47fc-b0ed-88a37593b8fa"
  client_id         = "8871760d-73a5-439f-b9f1-0c252581ad10"
  client_secret     = "Q8Z8Q~HFxcsP.d7yh7dLdnnnnaAvKMdlXlhx8aHI"
}

resource "azurerm_resource_group" "platform1_rg" {
  name     = "platform1rg1"
  location = "North Europe"
}

resource "azurerm_container_registry" "platform1_cr" {
  name                = "platform1cr1"
  resource_group_name = azurerm_resource_group.platform1_rg.name
  location            = azurerm_resource_group.platform1_rg.location
  sku                 = "Premium"
}

resource "azurerm_kubernetes_cluster" "platform1_aks" {
  name                = "platform1aks1"
  location            = azurerm_resource_group.platform1_rg.location
  resource_group_name = azurerm_resource_group.platform1_rg.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_role_assignment" "pltform1_ra" {
  principal_id                     = azurerm_kubernetes_cluster.platform1_aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.platform1_cr.id
  skip_service_principal_aad_check = true
}
