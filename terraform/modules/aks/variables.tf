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

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
}

variable "vm_size" {
  description = "VM size for nodes"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for AKS"
  type        = string
}

variable "min_count" {
  description = "Minimum node count"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum node count"
  type        = number
  default     = 3
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
}

variable "acr_id" {
  description = "Azure Container Registry ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}