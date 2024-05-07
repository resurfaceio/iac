
locals {
  _supported_providers   = ["azure", "aws", "gcp", "ibm-openshift"]
  _default_providers     = var.cloud_provider == "all" ? local._supported_providers : [var.cloud_provider]
  _unsupported_providers = toset(var.cpu_arch == "x86" ? [] : ["ibm-openshift"])
  providers              = setsubtract(toset(coalescelist(var.cloud_providers, local._default_providers)), local._unsupported_providers)
}

provider "azurerm" {
  features {}

  client_id       = try(jsondecode(file(var.azure_sp_path)).appId, "")
  client_secret   = try(jsondecode(file(var.azure_sp_path)).password, "")
  tenant_id       = try(jsondecode(file(var.azure_sp_path)).tenant, "")
  subscription_id = var.azure_subscription_id

  skip_provider_registration   = true
  disable_terraform_partner_id = true
}

provider "aws" {
  region                   = var.aws_region
  profile                  = var.aws_profile
  shared_config_files      = [var.aws_config_path]
  shared_credentials_files = [var.aws_creds_path]
}

provider "google" {
  credentials = var.gcp_adc_path
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "ibm" {
  region           = var.ibmc_region
  ibmcloud_api_key = try(jsondecode(file(var.ibmc_key_path)).apikey, "")
}

provider "local" {}


module "aks" {
  count  = contains(local.providers, "azure") ? 1 : 0
  source = "./modules/aks"
  service_principal = {
    client_id     = try(jsondecode(file(var.azure_sp_path)).appId, "")
    client_secret = try(jsondecode(file(var.azure_sp_path)).password, "")
  }
  region           = var.azure_region
  resource_group   = var.azure_resource_group
  use_existing_rg  = var.azure_use_existing_rg
  prefix           = var.prefix
  cpu_arch         = var.cpu_arch
  node_count       = var.node_count
  kube_config_path = var.aks_kubeconfig_dir
}

module "helm_aks" {
  source                = "./modules/helm"
  is_local_chart        = var.helm_use_local_chart
  local_chart_path      = var.helm_use_local_chart ? var.helm_local_chart_path : ""
  resurface_app_version = var.helm_resurface_app_version
  timeout               = var.helm_timeout

  cloud_provider     = "azure"
  skip_release       = var.skip_helm || !contains(local.providers, "azure")
  kube_config_source = "file"
  kube_config        = length(module.aks) > 0 ? module.aks[0].cluster_kubeconfig : local._empty[0].cluster_kubeconfig
  kube_config_path   = length(module.aks) > 0 ? module.aks[0].cluster_config_file : local._empty[0].cluster_config_file

  multinode_enabled       = var.helm_multinode_enabled
  worker_count            = var.helm_multinode_worker_count
  iceberg_enabled         = var.helm_iceberg_enabled
  tls_enabled             = var.helm_tls_enabled
  tls_host                = var.helm_tls_host_azure
  tls_autoissue_email     = var.helm_tls_autoissue_email
  auth_enabled            = var.helm_auth_enabled
  cert_manager_version    = var.helm_cert_manager_chart_version
  resurface_chart_version = var.helm_resurface_chart_version
}


module "eks" {
  count              = contains(local.providers, "aws") ? 1 : 0
  source             = "./modules/eks"
  region             = var.aws_region
  availability_zones = var.aws_zones
  prefix             = var.prefix
  cpu_arch           = var.cpu_arch
  node_count         = var.node_count
  kube_config_path   = var.eks_kubeconfig_dir
}

module "helm_eks" {
  source                = "./modules/helm"
  is_local_chart        = var.helm_use_local_chart
  local_chart_path      = var.helm_use_local_chart ? var.helm_local_chart_path : ""
  resurface_app_version = var.helm_resurface_app_version
  timeout               = var.helm_timeout

  cloud_provider     = "aws"
  skip_release       = var.skip_helm || !contains(local.providers, "aws")
  kube_config_source = "file"
  kube_config        = length(module.eks) > 0 ? module.eks[0].cluster_kubeconfig : local._empty[0].cluster_kubeconfig
  kube_config_path   = length(module.eks) > 0 ? module.eks[0].cluster_config_file : local._empty[0].cluster_config_file

  multinode_enabled       = var.helm_multinode_enabled
  worker_count            = var.helm_multinode_worker_count
  iceberg_enabled         = var.helm_iceberg_enabled
  tls_enabled             = var.helm_tls_enabled
  tls_host                = var.helm_tls_host_azure
  tls_autoissue_email     = var.helm_tls_autoissue_email
  auth_enabled            = var.helm_auth_enabled
  cert_manager_version    = var.helm_cert_manager_chart_version
  resurface_chart_version = var.helm_resurface_chart_version
}


module "gke" {
  count      = contains(local.providers, "gcp") ? 1 : 0
  source     = "./modules/gke"
  region     = var.gcp_region
  zone       = var.gcp_zone
  project_id = var.gcp_project_id
  cpu_arch   = var.cpu_arch
  node_count = var.node_count

  kube_config_path = var.gke_kubeconfig_dir
}

module "helm_gke" {
  source                = "./modules/helm"
  is_local_chart        = var.helm_use_local_chart
  local_chart_path      = var.helm_use_local_chart ? var.helm_local_chart_path : ""
  resurface_app_version = var.helm_resurface_app_version
  timeout               = var.helm_timeout

  cloud_provider     = "gcp"
  skip_release       = var.skip_helm || !contains(local.providers, "gcp")
  kube_config_source = "file"
  kube_config        = length(module.gke) > 0 ? module.gke[0].cluster_kubeconfig : local._empty[0].cluster_kubeconfig
  kube_config_path   = length(module.gke) > 0 ? module.gke[0].cluster_config_file : local._empty[0].cluster_config_file

  multinode_enabled       = var.helm_multinode_enabled
  worker_count            = var.helm_multinode_worker_count
  iceberg_enabled         = var.helm_iceberg_enabled
  tls_enabled             = var.helm_tls_enabled
  tls_host                = var.helm_tls_host_azure
  tls_autoissue_email     = var.helm_tls_autoissue_email
  auth_enabled            = var.helm_auth_enabled
  cert_manager_version    = var.helm_cert_manager_chart_version
  resurface_chart_version = var.helm_resurface_chart_version
}


module "ibm_oc" {
  count            = contains(local.providers, "ibm-openshift") ? 1 : 0
  source           = "./modules/ibm-oc"
  zone             = var.ibmc_zone
  resource_group   = var.ibmc_resource_group
  prefix           = var.prefix
  kube_config_path = var.ibm_openshift_kubeconfig_dir
}

locals {
  _empty = [{
    cluster_config_file      = "~/.kube/config"
    cluster_ingress_hostname = ""
    cluster_config_ctx       = null
    cluster_kubeconfig = {
      cluster_name    = ""
      cluster_ca_cert = ""
      host            = ""
      username        = ""
      password        = ""
      token           = ""
      client_cert     = ""
      client_key      = ""
    }
  }]
}

module "helm_ibm_oc" {
  source                = "./modules/helm"
  is_local_chart        = var.helm_use_local_chart
  local_chart_path      = var.helm_use_local_chart ? var.helm_local_chart_path : ""
  resurface_app_version = var.helm_resurface_app_version
  timeout               = var.helm_timeout

  cloud_provider     = "ibm-openshift"
  skip_release       = var.skip_helm || !contains(local.providers, "ibm-openshift")
  kube_config_source = "file"
  kube_config        = length(module.ibm_oc) > 0 ? module.ibm_oc[0].cluster_kubeconfig : local._empty[0].cluster_kubeconfig
  kube_config_path   = length(module.ibm_oc) > 0 ? module.ibm_oc[0].cluster_config_file : local._empty[0].cluster_config_file

  multinode_enabled       = var.helm_multinode_enabled
  worker_count            = var.helm_multinode_worker_count
  iceberg_enabled         = var.helm_iceberg_enabled
  tls_enabled             = var.helm_tls_enabled
  tls_host                = length(module.ibm_oc) > 0 ? module.ibm_oc[0].cluster_ingress_hostname : local._empty[0].cluster_ingress_hostname
  tls_autoissue_email     = var.helm_tls_autoissue_email
  auth_enabled            = var.helm_auth_enabled
  cert_manager_version    = var.helm_cert_manager_chart_version
  resurface_chart_version = var.helm_resurface_chart_version
}
