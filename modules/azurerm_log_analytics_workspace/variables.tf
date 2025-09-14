variable "workspace_name" {}
variable "location" {}
variable "rg_name" {}
variable "sku" {
  description = "The SKU of the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}
variable "retention_in_days" {
  description = "The workspace data retention in days"
  type        = number
  default     = 30
}
variable "tags" {}
