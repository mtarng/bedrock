module "provider" {
  source = "../../azure/provider"
}

# Read AKS cluster service principal (client) object to create a role assignment
data "azuread_service_principal" "sp" {
  application_id = "${var.service_principal_id}"
}

data "azurerm_client_config" "current" {}

module "keyvault_flexvol_role" {	
  source = "../../azure/keyvault_flexvol_role"

  resource_group_name      = "${var.keyvault_resource_group}"	
  service_principal_id     = "${var.service_principal_id}"	
  service_principal_secret = "${var.service_principal_secret}"	
  tenant_id                = "${data.azurerm_client_config.current.tenant_id}"	
  subscription_id          = "${data.azurerm_client_config.current.subscription_id}"	
  keyvault_name            = "${var.keyvault_name}"	
}