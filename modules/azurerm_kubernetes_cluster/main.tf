resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = var.dns_prefix

  # Security: Limit API server access to specific IP ranges
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  # Security: Enable RBAC
  role_based_access_control_enabled = true

  # Security: Configure network policy
  network_policy = "azure"

  # Security: Enable logging
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  default_node_pool {
    name       = "default"
    node_count = var.node_count 
    vm_size    = var.vm_size 
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}