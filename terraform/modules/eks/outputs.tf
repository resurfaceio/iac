output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.cluster.name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.cluster.arn
}

output "cluster_config_file" {
  description = "EKS cluster config yaml file location"
  value       = local_file.cluster_config.filename
}

output "cluster_kubeconfig" {
  description = "EKS cluster config Terraform object"
  value = {
    cluster_name    = aws_eks_cluster.cluster.name
    cluster_ca_cert = data.aws_eks_cluster.cluster.certificate_authority[0].data
    host            = data.aws_eks_cluster.cluster.endpoint
    username        = ""
    password        = ""
    token           = data.aws_eks_cluster_auth.cluster_auth.token
    client_cert     = ""
    client_key      = ""
  }
}
