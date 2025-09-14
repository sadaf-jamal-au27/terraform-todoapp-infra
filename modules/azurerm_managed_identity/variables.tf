variable "identity_name" {
  description = "Name of the managed identity"
  type        = string
}

variable "location" {
  description = "Azure location where the managed identity will be created"
  type        = string
}

variable "rg_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the managed identity"
  type        = map(string)
  default     = {}
}
