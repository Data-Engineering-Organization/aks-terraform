terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Beginner setup: state is stored in a local file (terraform.tfstate).
  # For team use, move state to an Azure Storage Account (azurerm backend).
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
