resource "azurerm_resource_group" "rg" {
  count    = var.use_existing_rg ? 0 : 1
  name     = var.resource_group
  location = var.region
}

data "azurerm_resource_group" "rg" {
  count = var.use_existing_rg ? 1 : 0
  name  = var.resource_group
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${var.prefix}cluster"
  location            = var.region
  resource_group_name = var.use_existing_rg ? data.azurerm_resource_group.rg[0].name : azurerm_resource_group.rg[0].name
  dns_prefix          = "${var.prefix}cluster-dns"
  kubernetes_version  = var.kube_version

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_D2s_v3"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.service_principal.client_id
    client_secret = var.service_principal.client_secret
  }

  role_based_access_control_enabled = true
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = var.cpu_arch == "x86" ? "Standard_D8as_v5" : "Standard_D8ps_v5"
  node_count            = var.node_count
  os_disk_size_gb       = 30
  os_type               = "Linux"
}

resource "local_file" "cluster_config" {
  filename        = "${var.kube_config_path}/${azurerm_kubernetes_cluster.cluster.name}-config.yml"
  file_permission = 400
  content         = azurerm_kubernetes_cluster.cluster.kube_config_raw
}
