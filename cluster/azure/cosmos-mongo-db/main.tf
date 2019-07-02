resource "azurerm_resource_group" "cosmosdb-rg" {
  name     = "${var.prefix}-rg"
  location = "${var.resource_group_location}"
}

resource "azurerm_cosmosdb_account" "cosmosdb-account" {
  name                = "${var.prefix}-cosmosdb"
  location            = "${azurerm_resource_group.cosmosdb-rg.location}"
  resource_group_name = "${azurerm_resource_group.cosmosdb-rg.name}"
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    prefix            = "${var.prefix}-customid"
    location          = "${azurerm_resource_group.cosmosdb-rg.location}"
    failover_priority = 0
  }
}

# TODO: Move this to a separate module.
resource "azurerm_cosmosdb_mongo_database" "example" {
  name                = "${var.prefix}-cosmos-mongo-db"
  resource_group_name = "${azurerm_cosmosdb_account.cosmosdb-account.resource_group_name}"
  account_name        = "${azurerm_cosmosdb_account.cosmosdb-account.name}"
}