variable "prefix" {
  description = "Prefix to use with all resources"
  type        = string
  default     = ""
}

variable "zone" {
  description = "IBM Cloud zone"
  type        = string
  default     = "us-south-1"
}

variable "resource_group" {
  description = "IBM Cloud resource group"
  type        = string
  nullable    = false
}

variable "openshift_version" {
  description = "Version of IBM Cloud OpenShift"
  type        = string
  default     = "4.13_openshift"
}

variable "openshift_vm_type" {
  description = "VM type for IBM Cloud OpenShift worker nodes"
  type        = string
  default     = "bx2.8x32"
}

variable "openshift_pool_size" {
  description = "Number of IBM Cloud OpenShift workers"
  type        = number
  default     = 4
}

variable "config_is_admin" {
  description = "Download the TLS certificates and permission files for the Super User cluster role."
  type        = bool
  default     = false
}

variable "kube_config_path" {
  description = "Directory path on your local machine where the cluster configuration file will be downloaded to."
  type        = string
  default     = "."
}
