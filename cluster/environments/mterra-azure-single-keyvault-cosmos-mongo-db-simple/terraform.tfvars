
#--------------------------------------------------------------
# keyvault, vnet, and subnets are created seperately by azure-common-infra
#--------------------------------------------------------------
keyvault_name = "mterra-keyvault"
keyvault_resource_group = "mterra-rg" # TODO: Rename to "global-rg"

address_space = ""
subnet_prefixes = ""
vnet_subnet_id = ""

#--------------------------------------------------------------
# CosmosDB & MongoDB variables
#--------------------------------------------------------------

# resource_group_name = "${keyvault_resource_group}" # Piggybacking off global rg for CosmosDB
cosmos_db_name = "my-cosmos-db-name"
mongo_db_name = "my-mongo-db-name"
# cosmos_db_offer_type = "Standard" - Optional field

#--------------------------------------------------------------
# Cluster variables
#--------------------------------------------------------------
agent_vm_count = "3"
agent_vm_size = "Standard_D4s_v3"

cluster_name = "mterra-cosmos-mongo"
dns_prefix = "mterra-cosmos-mongo"

gitops_ssh_url = "git@github.com:Microsoft/fabrikate-production-cluster-demo-materialized"
gitops_ssh_key = "/Users/mtarng/go/src/github.com/microsoft/bedrock/cluster/environments/mterra-azure-single-keyvault-cosmos-mongo-db-simple/gitops_repo_key"

resource_group_name = "mterra-azure-cosmos-mongo-rg"
resource_group_location = "westus2"

ssh_public_key = ""

service_principal_id = ""
service_principal_secret = ""

#--------------------------------------------------------------
# Optional variables - Uncomment to use
#--------------------------------------------------------------
# gitops_url_branch = "release-123"
# gitops_poll_interval = "30s"
# gitops_path = "prod"
