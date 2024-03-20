output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.cluster.name
}

output "cluster_config_ctx" {
  description = "Context for the cluster configuration"
  value       = google_container_cluster.cluster.name
}

output "cluster_config_file" {
  description = "GKE cluster config yaml file location"
  value       = local_file.cluster_config.filename
}

output "cluster_kubeconfig" {
  description = "GKE cluster config Terraform object"
  value       = {
    cluster_name    = google_container_cluster.cluster.name
    cluster_ca_cert = google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
    host            = google_container_cluster.cluster.endpoint
    username        = ""
    password        = ""
    token           = data.google_client_config.default.access_token
    client_cert     = google_container_cluster.cluster.master_auth.0.client_certificate
    client_key      = google_container_cluster.cluster.master_auth.0.client_key
  }
}
