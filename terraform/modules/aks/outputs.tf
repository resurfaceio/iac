output "cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.cluster.name
}

output "cluster_config_file" {
  description = "AKS cluster config yaml file location"
  value       = local_file.cluster_config.filename
}

output "cluster_kubeconfig" {
  description = "AKS cluster config Terraform object"
  value       = {
    cluster_ca_cert = azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
    host            = azurerm_kubernetes_cluster.cluster.kube_config[0].host
    username        = azurerm_kubernetes_cluster.cluster.kube_config[0].username
    password        = azurerm_kubernetes_cluster.cluster.kube_config[0].password
    token           = azurerm_kubernetes_cluster.cluster.kube_config[0].password
    client_cert     = azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate
    client_key      = azurerm_kubernetes_cluster.cluster.kube_config[0].client_key
  }
}
