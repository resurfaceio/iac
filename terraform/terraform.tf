terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.75.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.16.2"
    }
    google = {
      source  = "hashicorp/google"
      version = "< 4.4.0"
    }
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.12.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.1"
    }
  }

  required_version = ">= 0.13.7"
}
