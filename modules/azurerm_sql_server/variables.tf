variable "sql_server_name" {}
variable "rg_name" {}
variable "location" {}
variable "admin_username" {}
variable "admin_password" {}
variable "tags" {}

# Security variables
variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the SQL server"
  type        = bool
  default     = false
}

variable "audit_storage_endpoint" {
  description = "Storage endpoint for SQL server audit logs"
  type        = string
  default     = null
}

variable "audit_storage_access_key" {
  description = "Storage access key for SQL server audit logs"
  type        = string
  default     = null
  sensitive   = true
}

variable "audit_retention_days" {
  description = "Number of days to retain audit logs"
  type        = number
  default     = 90
}