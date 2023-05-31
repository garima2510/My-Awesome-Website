variable "resource_group_location" {
  default     = "northeurope"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  default     = "rg-al-website"
  description = "Name of the resource group where website will be deployed"
}

variable "storage_account_name" {
  default     = "stgstaticwebsite21"
  description = "Name of the storage account where website will be deployed"
}
  