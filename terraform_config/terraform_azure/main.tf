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

# Container Group
resource "azurerm_container_group" "nextjs_container_group" {
  name                = "nextjs-container-group"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
  os_type             = "Linux"

  container {
    name   = "nextjs-container"
    image  = "julia8893/nextjs-app:1.0"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      NODE_ENV = "production"
    }
  }

  tags = {
    environment = "student_account"
  }
}

