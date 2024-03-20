variable "cloud_provider" {
  description = "Kubernetes cluster cloud provider"
  type        = string
  default     = ""
}

variable "is_local_chart" {
  description = "Set to true if using a local chart"
  type        = bool
  default     = false
}

variable "local_chart_path" {
  description = "Local chart path"
  type        = string
  default     = "."
}

variable "kube_config" {
  description = "Kubernetes cluster config object"
  type = object({
    host            = string
    username        = string
    password        = string
    token           = string
    client_cert     = string
    client_key      = string
    cluster_ca_cert = string
  })
  default = {
    cluster_ca_cert = ""
    host            = ""
    username        = ""
    password        = ""
    token           = ""
    client_cert     = ""
    client_key      = ""
  }
}

variable "kube_config_path" {
  description = "Kubernetes cluster config file path"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_config_source" {
  description = "Kubernetes cluster config source"
  type        = string
  validation {
    condition     = contains(["file", "basic", "token"], var.kube_config_source)
    error_message = "The only support kubeconfig sources are: \"file\", \"basic\", \"token\""
  }
  default = "obj"
}

variable "multinode_enabled" {
  description = "Set to true to enable multinode mode"
  type        = bool
  default     = false
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}

variable "iceberg_enabled" {
  description = "Set to true to enable iceberg mode"
  type        = bool
  default     = false
}

variable "tls_enabled" {
  description = "Set to true to install cert-manager chart"
  type        = bool
  default     = false
}

variable "tls_host" {
  description = "Host for Ingress TLS configuration"
  type        = string
  default     = "neptune"
}

variable "tls_autoissue_email" {
  description = "Let's encrypt notifications will be sent to this address"
  type        = string
  default     = "foo@bar.com"
}

variable "auth_enabled" {
  description = "Set to true to enable basic auth"
  type        = bool
  default     = false
}

variable "cert_manager_version" {
  description = "Cert-manager chart version"
  type        = string
  default     = "v1.14.4"
}

variable "resurface_chart_version" {
  description = "Resurface chart version"
  type        = string
  default     = "3.6.11"
}

variable "resurface_app_version" {
  description = "Resurface container version"
  type        = string
  default     = ""
}

variable "timeout" {
  description = "Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks)"
  type        = number
  default     = 300
}

variable "skip_release" {
  description = "Set to true to skip installation"
  type        = bool
  default     = false
}
