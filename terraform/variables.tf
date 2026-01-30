variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "devsu-demo-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "devsudemo"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28.3"
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "Size of the VMs in the AKS cluster"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "letsencrypt_email" {
  description = "Email for Let's Encrypt certificates"
  type        = string
  default     = "CHANGE-THIS@yourdomain.com"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "production"
    Project     = "devsu-demo"
    ManagedBy   = "terraform"
  }
}