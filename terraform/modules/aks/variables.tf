variable "prefix" {
  description = "Prefix to use with all resources"
  type        = string
  default     = ""
}

variable "service_principal" {
  description = "Azure Service Principal to create the cluster under"
  type = object({
    client_id     = string
    client_secret = string
  })
  sensitive = true
  nullable  = false
}

variable "region" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group" {
  description = "Azure resource group"
  type        = string
  nullable    = false
}

variable "use_existing_rg" {
  description = "Set to true if resource group already exists"
  type        = bool
  default     = false
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 3
}

variable "kube_version" {
  description = "AKS version"
  type        = string
  default     = "1.27.9"
}

variable "cpu_arch" {
  description = "CPU architecture for node pool VMs"
  type        = string
  validation {
    condition     = var.cpu_arch == "x86" || var.cpu_arch == "arm64"
    error_message = "The only supported architectures are x86 and arm64"
  }
  default = "x86"
}

variable "kube_config_path" {
  description = "Directory path on your local machine where the cluster configuration file will be downloaded to"
  type        = string
  default     = "."
}
