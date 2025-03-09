# Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

# Define the resource group
resource "azurerm_resource_group" "rg" {
  name = "${var.labelPrefix}-h09-aks"
  location = var.region
}

resource "azurerm_kubernetes_cluster" "aks" {
  name = "${var.labelPrefix}h09aks"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  dns_prefix = "${var.labelPrefix}aks"

  default_node_pool {
    name = "default"
    node_count = 1
    vm_size = "Standard_B2s"
    min_count = 1
    max_count = 3
    enable_auto_scaling = true
  }

  identity {
    type = "SystemAssigned"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}