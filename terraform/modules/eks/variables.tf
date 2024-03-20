variable "prefix" {
  description = "Prefix to use with all resources"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "AWS availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  validation {
    error_message = "Please provide 3 AZ"
    condition     = length(var.availability_zones) == 3
  }
}
variable "vpc_cidr" {
  description = "CIDR for new AWS VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDRs for new AWS Subnets"
  type        = list(string)
  default     = ["10.10.0.0/20", "10.10.16.0/20", "10.10.32.0/20"]
  validation {
    error_message = "Please provide 3 subnet CIDRs"
    condition     = length(var.subnet_cidrs) == 3
  }
}

variable "node_count" {
  description = "Number of EKS nodes"
  type        = number
  default     = 3
}

variable "kube_version" {
  description = "EKS Version"
  type        = string
  default     = "1.29"
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
