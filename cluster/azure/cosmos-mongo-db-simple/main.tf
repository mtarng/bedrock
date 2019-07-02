#Simple CosmosDB/MongoDB deployment. No multiregion failover support.

resource "azurerm_resource_group" "cosmosdb_rg" {
  # name     = "${var.prefix}_rg" 
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}
# TODO: Change to data, use global resource group.

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "${var.cosmos_db_name}"
  location            = "${azurerm_resource_group.cosmosdb_rg.location}"
  resource_group_name = "${azurerm_resource_group.cosmosdb_rg.name}"
  offer_type          = "${var.cosmos_db_offer_type}"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    prefix            = "${var.cosmos_db_name}-customid"
    location          = "${azurerm_resource_group.cosmosdb_rg.location}"
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "mongo_db" {
  name                = "${var.mongo_db_name}"
  resource_group_name = "${azurerm_cosmosdb_account.cosmosdb_account.resource_group_name}"
  account_name        = "${azurerm_cosmosdb_account.cosmosdb_account.name}"
}