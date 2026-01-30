variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_address_prefixes" {
  description = "Address prefixes for AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "gateway_subnet_address_prefixes" {
  description = "Address prefixes for gateway subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}