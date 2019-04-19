data "azuread_service_principal" "flexvol" {
  application_id = "${var.service_principal_id}"
}

resource "azurerm_role_assignment" "flexvol" {
  principal_id         = "${data.azuread_service_principal.flexvol.id}"
  role_definition_name = "${var.flexvol_role_assignment_role}"
  scope                = "/subscriptions/${var.subscription_id}/resourcegroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${var.keyvault_name}"
}

resource "azurerm_key_vault_access_policy" "flexvol" {
  vault_name          = "${var.keyvault_name}"
  resource_group_name = "${var.resource_group_name}"

  tenant_id = "${var.tenant_id}"
  object_id = "${data.azuread_service_principal.flexvol.id}"

  key_permissions = "${var.flexvol_keyvault_key_permissions}"
  secret_permissions = "${var.flexvol_keyvault_secret_permissions}"
  certificate_permissions = "${var.flexvol_keyvault_certificate_permissions}"
}