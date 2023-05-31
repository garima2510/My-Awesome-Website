# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.58.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "azurerm" {
  features {}
}