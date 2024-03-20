# Graylog API Security on Azure Kubernetes Service

## Resources

- `azurerm_resource_group`: Azure Resource Group
- `azurerm_kubernetes_cluster`: AKS cluster
- `azurerm_kubernetes_cluster_node_pool`: AKS node pool

## Variables

- `prefix"`: Prefix to use with all resources
- `service_principal"`: Azure Service Principal to create the cluster under
- `region"`: Azure region
- `resource_group"`: Azure resource group
- `use_existing_rg"`: Set to true if resource group already exists
- `node_count"`: Number of AKS nodes
- `kube_version"`: AKS version
- `cpu_arch"`: CPU architecture for node pool VMs
- `kube_config_path"`: Directory path on your local machine where the cluster configuration file will be downloaded to

## Outputs

- `cluster_name`: AKS cluster name
- `cluster_config_file`: AKS cluster config yaml file location