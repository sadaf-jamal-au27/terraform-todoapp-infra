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
