data "azurerm_client_config" "current" {}

#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

#Create Storage Account
resource "azurerm_storage_account" "stg_acc" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.storage_account_name
  location            = var.resource_group_location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_0"

  static_website {
    index_document = "index.html"
    //error_404_document = "404.html"
  }
}

#Add index.html to blob storage
resource "azurerm_storage_blob" "web_files" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.stg_acc.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "index.html"
}

