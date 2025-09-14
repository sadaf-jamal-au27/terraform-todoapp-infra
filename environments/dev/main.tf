locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "TodoAppTeam"
    "Environment" = "dev"
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
  rg_name     = "rg-dev-todoapp"
  rg_location = "centralindia"
  rg_tags     = local.common_tags
}

module "rg1" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg-dev-todoapp-1"
  rg_location = "centralindia"
  rg_tags     = local.common_tags
}

module "acr" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_container_registry"
  acr_name   = "acrdevtodoapp${random_id.acr_suffix.hex}"
  rg_name    = "rg-dev-todoapp"
  location   = "centralindia"
  tags       = local.common_tags
}

module "sql_server" {
  depends_on                    = [module.rg]
  source                        = "../../modules/azurerm_sql_server"
  sql_server_name               = "sql-dev-todoapp-${random_id.sql_suffix.hex}"
  rg_name                       = "rg-dev-todoapp"
  location                      = "centralindia"
  admin_username                = "devopsadmin"
  admin_password                = var.sql_admin_password
  public_network_access_enabled = true  # Allow public access for dev
  tags                          = local.common_tags
}

module "sql_db" {
  depends_on  = [module.sql_server]
  source      = "../../modules/azurerm_sql_database"
  sql_db_name = "sqldb-dev-todoapp"
  server_id   = module.sql_server.server_id
  max_size_gb = "2"
  tags        = local.common_tags
}

module "log_analytics" {
  depends_on     = [module.rg]
  source         = "../../modules/azurerm_log_analytics_workspace"
  workspace_name = "law-dev-todoapp"
  location       = "centralindia"
  rg_name        = "rg-dev-todoapp"
  tags           = local.common_tags
}

module "aks" {
  depends_on                     = [module.rg, module.log_analytics]
  source                         = "../../modules/azurerm_kubernetes_cluster"
  aks_name                       = "aks-dev-todoapp"
  location                       = "centralindia"
  rg_name                        = "rg-dev-todoapp"
  dns_prefix                     = "aks-dev-todoapp"
  vm_size                        = "Standard_B2s"
  api_server_authorized_ip_ranges = ["0.0.0.0/0"]  # Allow all for dev, restrict in prod
  log_analytics_workspace_id     = module.log_analytics.workspace_id
  tags                           = local.common_tags
}


module "pip" {
  source   = "../../modules/azurerm_public_ip"
  pip_name = "pip-dev-todoapp"
  rg_name  = "rg-dev-todoapp"
  location = "centralindia"
  sku      = "Standard"
  tags     = local.common_tags
}
