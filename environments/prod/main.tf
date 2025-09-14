locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "TodoAppTeam"
    "Environment" = "prod"
  }
}

# Variables for sensitive data
variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
  default     = "P@ssw01rd@123"
}

# Random ID for unique naming
resource "random_id" "acr_suffix" {
  byte_length = 4
}

resource "random_id" "sql_suffix" {
  byte_length = 4
}

module "rg" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg-prod-todoapp"
  rg_location = "centralindia"
  rg_tags     = local.common_tags
}

module "rg1" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg-prod-todoapp-1"
  rg_location = "centralindia"
  rg_tags     = local.common_tags
}

module "acr" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_container_registry"
  acr_name   = "acrprodtodoapp${random_id.acr_suffix.hex}"
  rg_name    = "rg-prod-todoapp"
  location   = "centralindia"
  tags       = local.common_tags
}

module "sql_server" {
  depends_on                    = [module.rg]
  source                        = "../../modules/azurerm_sql_server"
  sql_server_name               = "sql-prod-todoapp-${random_id.sql_suffix.hex}"
  rg_name                       = "rg-prod-todoapp"
  location                      = "centralindia"
  admin_username                = "devopsadmin"
  admin_password                = var.sql_admin_password
  public_network_access_enabled = false # Disable public access for production
  tags                          = local.common_tags
}

module "sql_db" {
  depends_on  = [module.sql_server]
  source      = "../../modules/azurerm_sql_database"
  sql_db_name = "sqldb-prod-todoapp"
  server_id   = module.sql_server.server_id
  max_size_gb = "10"
  tags        = local.common_tags
}


module "aks" {
  depends_on                      = [module.rg]
  source                          = "../../modules/azurerm_kubernetes_cluster"
  aks_name                        = "aks-prod-todoapp"
  location                        = "centralindia"
  rg_name                         = "rg-prod-todoapp"
  dns_prefix                      = "aks-prod-todoapp"
  vm_size                         = "Standard_D2s_v3"
  api_server_authorized_ip_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"] # Restrict to private IPs
  tags                            = local.common_tags
}

module "pip" {
  source   = "../../modules/azurerm_public_ip"
  pip_name = "pip-prod-todoapp"
  rg_name  = "rg-prod-todoapp"
  location = "centralindia"
  sku      = "Standard"
  tags     = local.common_tags
}
