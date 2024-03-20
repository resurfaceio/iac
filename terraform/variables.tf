variable "cloud_provider" {
  description = "Cloud provider to deploy Kubernetes cluster"
  type        = string
  default     = ""
}

variable "cloud_providers" {
  description = "List of cloud providers to deploy Kubernetes clusters"
  type        = list(string)
  default     = []
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

variable "node_count" {
  description = "Number of Kubernetes nodes"
  type        = number
  default     = 1
}

# API Keys and Credentials

variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "azure_sp_path" {
  description = "Azure Service Principal JSON file path"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "aws_profile" {
  description = "AWS profile name as set in the shared configuration and credentials files"
  type        = string
  sensitive   = true
  default     = "default"
}

variable "aws_config_path" {
  description = "AWS shared configuration file path"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "aws_creds_path" {
  description = "AWS shared credentials file path"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "gcp_adc_path" {
  description = "GCP Application Default Credentials JSON file path"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "ibmc_key_path" {
  description = "IBM Cloud API Key JSON file path"
  type        = string
  sensitive   = true
  nullable    = false
}

# Resource Groups and Project IDs

variable "azure_resource_group" {
  description = "Azure resource group"
  type        = string
  nullable    = false
}

variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
  nullable    = false
}

variable "ibmc_resource_group" {
  description = "IBM Cloud resource group"
  type        = string
  nullable    = false
}

# Regions and Zones

variable "azure_region" {
  description = "Azure region"
  type        = string
  default     = "East US 2"
}

variable "azure_use_existing_rg" {
  description = "Set to true to use existing Resource Group"
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_zones" {
  description = "AWS availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  validation {
    error_message = "Please provide 3 AZ"
    condition     = length(var.aws_zones) == 3
  }
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "ibmc_region" {
  description = "IBM Cloud region"
  type        = string
  default     = "us-south"
}

variable "ibmc_zone" {
  description = "IBM Cloud zone"
  type        = string
  default     = "us-south-1"
}

# Kubeconfig directories

variable "aks_kubeconfig_dir" {
  description = "Directory path on your local machine where the AKS cluster configuration file will be downloaded to."
  type        = string
  default     = "."
}

variable "eks_kubeconfig_dir" {
  description = "Directory path on your local machine where the EKS cluster configuration file will be downloaded to."
  type        = string
  default     = "."
}

variable "gke_kubeconfig_dir" {
  description = "Directory path on your local machine where the GKE cluster configuration file will be downloaded to."
  type        = string
  default     = "."
}

variable "ibm_openshift_kubeconfig_dir" {
  description = "Directory path on your local machine where the IBM OpenShift cluster configuration file will be downloaded to."
  type        = string
  default     = "."
}

# Helm options

variable "helm_use_local_chart" {
  description = "Set to true if using a helm local chart"
  type        = bool
  default     = false
}

variable "helm_local_chart_path" {
  description = "Helm local chart directory path"
  type        = string
  default     = "."
}

variable "helm_timeout" {
  description = "Time in seconds to wait for any individual kubernetes operation (like jobs or hooks)"
  type        = number
  default     = 300
}

variable "skip_helm" {
  description = "Set to true to skip all helm installs"
  type        = bool
  default     = false
}

variable "helm_multinode_enabled" {
  description = "Set to true to enable multinode mode"
  type        = bool
  default     = false
}

variable "helm_multinode_worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}

variable "helm_iceberg_enabled" {
  description = "Set to true to enable iceberg mode"
  type        = bool
  default     = false
}

variable "helm_tls_enabled" {
  description = "Set to true to install cert-manager chart"
  type        = bool
  default     = false
}

variable "helm_tls_autoissue_email" {
  description = "Let's encrypt notifications will be sent to this address"
  type        = string
  default     = "foo@bar.com"
}

variable "helm_auth_enabled" {
  description = "Set to true to enable basic auth"
  type        = bool
  default     = false
}

variable "helm_cert_manager_chart_version" {
  description = "Cert-manager chart version"
  type        = string
  default     = "v1.14.4"
}

variable "helm_resurface_chart_version" {
  description = "Resurface chart version"
  type        = string
  default     = ""
}

variable "helm_resurface_app_version" {
  description = "Resurface chart version"
  type        = string
  default     = ""
}

# Hosts for TLS
variable "helm_tls_host_azure" {
  description = "Host included in the TLS certificate for the Resurface AKS service"
  type        = string
  default     = ""
}

variable "helm_tls_host_aws" {
  description = "Host included in the TLS certificate for the Resurface EKS service"
  type        = string
  default     = ""
}

variable "helm_tls_host_gcp" {
  description = "Host included in the TLS certificate for the Resurface GKE service"
  type        = string
  default     = ""
}

# Miscellaneous

variable "prefix" {
  description = "Prefix to use with all resources"
  type        = string
  default     = "qa-"
}

# variable "tags" {
#   description = "Tags to add to all resources that support them"
#   type = map(string)
#   default = {}
# }






