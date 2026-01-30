terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformstatedevsu"
    container_name       = "tfstate"
    key                  = "devsu-demo.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  project_name        = var.project_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"

  project_name        = var.project_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# Container Registry Module
module "acr" {
  source = "./modules/acr"

  project_name        = var.project_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# AKS Module
module "aks" {
  source = "./modules/aks"

  project_name               = var.project_name
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  kubernetes_version         = var.kubernetes_version
  node_count                 = var.node_count
  vm_size                    = var.vm_size
  subnet_id                  = module.networking.aks_subnet_id
  log_analytics_workspace_id = module.monitoring.id
  acr_id                     = module.acr.id
  tags                       = var.tags
}

# Application Gateway Module
module "gateway" {
  source = "./modules/gateway"

  project_name        = var.project_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.networking.gateway_subnet_id
  tags                = var.tags
}

# Kubernetes Add-ons Module (Optional - can be managed separately)
# module "k8s_addons" {
#   source = "./modules/k8s-addons"
#   
#   letsencrypt_email = var.letsencrypt_email
#   
#   providers = {
#     helm = helm
#     kubernetes = kubernetes
#   }
#   
#   depends_on = [module.aks]
# }