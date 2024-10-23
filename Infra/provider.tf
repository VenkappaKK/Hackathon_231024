terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.6.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "myapp_rg_statefile"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "wfd6aiaapiea"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "blob"                       # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"        # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}
