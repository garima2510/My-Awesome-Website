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
  enable_https_traffic_only = true
  allow_nested_items_to_be_public = true

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

#Create Key Vault
resource "azurerm_key_vault" "akv" {
  name = var.kv_name
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
  soft_delete_retention_days = 7
}

#Create Virtual network
resource "azurerm_virtual_network" "az_vnet" {
  name = "vnet-1"
  address_space = ["10.0.0.0/16"]
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
}

#Create Subnet
resource "azurerm_subnet" "az_subnet" {
  name                 = "internal"
  resource_group_name  = var.resource_group_location
  virtual_network_name = var.resource_group_name
  address_prefixes     = ["10.0.2.0/24"]
}

#Create Network Interface 
resource "azurerm_network_interface" "az_nic" {
  name = "nic-1"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.az_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create VM
resource "azurerm_windows_virtual_machine" "az_vm" {
  name = "vm-1"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  size = "Standard_B1s"
  admin_username = "iamazureadmin"
  admin_password = "MostSecurePwd@3593"
  network_interface_ids = [azurerm_network_interface.az_nic.id]
  os_disk {
    name = "osdisk-1"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2019-Datacenter"
    version = "latest"
  }
}