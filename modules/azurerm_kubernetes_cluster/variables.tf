variable "aks_name" {}
variable "location" {}
variable "rg_name" {}
variable "dns_prefix" {}
variable "node_count" {
  default = 1
}
variable "vm_size" {
  default = "Standard_D2_v2"
}
variable "tags" {}

# Security variables
variable "api_server_authorized_ip_ranges" {
  description = "List of IP ranges that can access the AKS API server"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default to allow all, should be restricted in production
}



