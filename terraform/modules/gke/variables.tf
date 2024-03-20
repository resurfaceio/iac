variable "project_id" {
  description = "GCP Project ID"
  type        = string
  nullable    = false
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "subnet_cidr" {
  description = "CIDR for new GKE subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "node_count" {
  description = "Number of GKE nodes"
  type        = number
  default     = 3
}

variable "kube_version_prefix" {
  description = "GKE Version string prefix to match"
  type        = string
  default     = "1.27."
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
