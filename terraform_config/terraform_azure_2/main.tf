# Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "terraform" {
  name     = "TerraformResourceGroup"
  location = "Germany West Central"
}

# App Service Plan
resource "azurerm_service_plan" "terraform" {
  name                = "terraform-service-plan"
  resource_group_name = azurerm_resource_group.terraform.name
  location            = azurerm_resource_group.terraform.location
  os_type             = "Linux"
  sku_name            = "FREE"
}

# App Service using a Docker container
resource "azurerm_app_service" "terraform" {
  name                = "terraform-app-8893"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
  app_service_plan_id = azurerm_service_plan.terraform.id

  # Specify Docker container settings
  site_config {
    linux_fx_version = "julia8893/nextjs-app:1.0"
  }
}

# FQDN
output "app_service_fqdn" {
  value = azurerm_app_service.terraform.default_site_hostname
}