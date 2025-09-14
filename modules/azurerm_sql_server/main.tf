resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  minimum_tls_version          = "1.2"

  # Security: Disable public network access
  public_network_access_enabled = var.public_network_access_enabled

  # Security: Enable extended audit policy
  extended_auditing_policy {
    storage_endpoint                        = var.audit_storage_endpoint
    storage_account_access_key              = var.audit_storage_access_key
    storage_account_access_key_is_secondary = false
    retention_in_days                       = var.audit_retention_days
  }

  tags = var.tags
}
