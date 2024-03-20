output "cluster_name" {
  value       = ibm_container_vpc_cluster.cluster.name
  description = "The name of the cluster."
}

output "cluster_status" {
  value       = ibm_container_vpc_cluster.cluster.state
  description = "The state of the cluster master."
}

output "cluster_ingress_hostname" {
  value       = ibm_container_vpc_cluster.cluster.ingress_hostname
  description = "The hostname of the cluster ingress resource."
}

output "cluster_config_ctx" {
  value       = "${ibm_container_vpc_cluster.cluster.name}/${data.ibm_container_cluster_config.cluster_config.id}"
  description = "Context for the cluster configuration."
}

output "cluster_config_file" {
  value       = data.ibm_container_cluster_config.cluster_config.config_file_path
  description = "The path on your local machine where the cluster configuration file and certificates are downloaded to."
}

# output "cluster_config_file" {
#   value       = local_file.cluster_config.filename
#   description = "IBM OpenShift cluster config file location"
# }

output "cluster_kubeconfig" {
  description = "GKE cluster config Terraform object"
  value       = {
    # cluster_ca_cert = data.ibm_container_cluster_config.cluster_config.ca_certificate
    cluster_ca_cert = ""
    host            = data.ibm_container_cluster_config.cluster_config.host
    username        = ""
    password        = ""
    token           = data.ibm_container_cluster_config.cluster_config.token
    client_cert     = data.ibm_container_cluster_config.cluster_config.admin_certificate
    client_key      = data.ibm_container_cluster_config.cluster_config.admin_key
  }
}

