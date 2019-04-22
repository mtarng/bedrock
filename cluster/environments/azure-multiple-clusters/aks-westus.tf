resource "azurerm_resource_group" "westrg" {
  name     = "${var.west_resource_group_name}"
  location = "${var.west_resource_group_location}"
}

# local variable with cluster and location specific
locals {
  west_rg_name                 = "${azurerm_resource_group.westrg.name}"
  west_rg_location             = "${azurerm_resource_group.westrg.location}"
  west_prefix                  = "${local.west_rg_location}_${var.cluster_name}"
  west_flux_clone_dir          = "${local.west_prefix}_flux"
  west_kubeconfig_filename     = "${local.west_prefix}_kube_config"
  west_ip_address_out_filename = "${local.west_prefix}_ip_address"
}

# Creates west vnet
module "west_vnet" {
  # source = "github.com/Microsoft/bedrock/cluster/azure/vnet"
  source = "../../azure/vnet"

  resource_group_name     = "${local.west_rg_name}"
  resource_group_location = "${local.west_rg_location}"
  subnet_names            = ["${var.cluster_name}_aks_subnet"]
  address_space           = "${var.west_address_space}"
  subnet_prefixes         = "${var.west_subnet_prefixes}"
  tags = {
    environment = "azure_multiple_clusters"
  }
}

# Creates west aks cluster, flux, kubediff
module "west_aks_gitops" {
  # source = "github.com/Microsoft/bedrock/cluster/azure/aks-gitops"
  source = "../../azure/aks-gitops"

  acr_enabled              = "${var.acr_enabled}"
  agent_vm_count           = "${var.agent_vm_count}"
  agent_vm_size            = "${var.agent_vm_size}"
  cluster_name             = "${var.cluster_name}"
  dns_prefix               = "${var.dns_prefix}"
  flux_recreate            = "${var.flux_recreate}"
  gitops_ssh_url           = "${var.gitops_ssh_url}"
  gitops_ssh_key           = "${var.gitops_ssh_key}"
  gitops_path              = "${var.gitops_west_path}"
  gitops_poll_interval     = "${var.gitops_poll_interval}"
  resource_group_location  = "${var.west_resource_group_location}"
  resource_group_name      = "${azurerm_resource_group.westrg.name}"
  service_cidr             = "${var.west_service_cidr}"
  service_principal_id     = "${var.service_principal_id}"
  service_principal_secret = "${var.service_principal_secret}"
  ssh_public_key           = "${var.ssh_public_key}"
  vnet_subnet_id           = "${module.west_vnet.vnet_subnet_ids[0]}"
  dns_ip                   = "${var.west_dns_ip}"
  docker_cidr              = "${var.west_docker_cidr}"
  kubeconfig_filename      = "${local.west_kubeconfig_filename}"
}

module "west_flex_volume" {	
  # source = "github.com/Microsoft/bedrock/cluster/azure/keyvault_flexvol"	
  source = "../../azure/keyvault_flexvol"	

  resource_group_name      = "${var.keyvault_resource_group}"	
  service_principal_id     = "${var.service_principal_id}"	
  service_principal_secret = "${var.service_principal_secret}"	
  tenant_id                = "${data.azurerm_client_config.current.tenant_id}"	
  subscription_id          = "${data.azurerm_client_config.current.subscription_id}"	
  keyvault_name            = "${var.keyvault_name}"	

   kubeconfig_complete = "${module.west_aks_gitops.aks_flux_kubediff_done}"	
}

# create a static public ip and associate with traffic manger endpoint
module "west_tm_endpoint" {
  # source = "github.com/Microsoft/bedrock/cluster/azure/tm-endpoint-ip"
  source = "../../azure/tm-endpoint-ip"

  resource_group_name                 = "${local.west_rg_name}"
  resource_location                   = "${local.west_rg_location}"
  traffic_manager_resource_group_name = "${var.traffic_manager_resource_group_name}"
  traffic_manager_profile_name        = "${var.traffic_manager_profile_name}"
  endpoint_name                       = "${local.west_rg_location}_${var.cluster_name}"
  public_ip_name                      = "${var.cluster_name}"
  ip_address_out_filename             = "${local.west_ip_address_out_filename}"

  tags = {
    environment = "azure_multiple_clusters - ${local.west_prefix} - public ip"
    kubedone = "${module.west_aks_gitops.kubeconfig_done}"
  }
}

# Create a role assignment with Contributor role for AKS client service principal object
#   to join vnet/subnet/ip for load balancer/ingress controller
resource "azurerm_role_assignment" "west_spra" {
  principal_id         = "${data.azuread_service_principal.sp.id}"
  role_definition_name = "${var.aks_client_role_assignment_role}"
  scope                = "${azurerm_resource_group.westrg.id}"
}
