variable "resource_group_name" {
  description = "The resource group name for this cosmos db"
  type = "string"
}

variable "resource_group_location" {
  description = "The region for this resource group"
  type = "string"
}

variable "cosmos_db_name" {
  description = "CosmosDB name"
  type = "string"
}

variable "cosmos_db_offer_type" {
  type = "string"
  default = "Standard"
}

variable "mongo_db_name" {
  description = "MongoDB name"
  type = "string"
}