# Graylog API Security on Google Kubernetes Engine

## Resources

- VPC
- Subnet
- GKE cluster
- GKE node pool
- kubeconfig file

## Variables

- `adc_path`: Path to local JSON file containing GCP Application Default Credentials
- `project_id`: GCP Project ID
- `region`: GCP region
- `zone`: GCP zone
- `subnet_cidr`: CIDR for new GKE subnet
- `node_count`: Number of GKE nodes
- `kube_version_prefix`: GKE Version string prefix to match
- `cpu_arch`: CPU architecture for node pool VMs
- `config_path`: Directory path on your local machine where the cluster configuration file will be downloaded to

## Outputs

- `cluster_name`: GKE cluster name
- `cluster_config_ctx`: Context for the cluster configuration
- `cluster_config`: GKE cluster config yaml file location