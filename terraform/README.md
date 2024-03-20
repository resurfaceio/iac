# Terraform modules

Create Kubernetes clusters on any of the supported cloud environments: Azure, AWS, GCP, IBM Cloud

## Installation and Usage

Make sure the `.terraform` directory has been initialized

```bash
terraform init
```

A cloud provider must be specified:

```bash
terraform apply -var 'cloud_provider=aws'
```

Or a list of providers:

```bash
terraform apply -var 'cloud_providers=["azure", "aws"]'
```

Make sure to also set the corresponding credentials

| Provider | Variable | Description |
|---|---|---|
| azure    | azure_subscription_id | 
| azure | azure_subscription_id | Azure Subscription ID |
| azure | azure_sp_path | Azure Service Principal JSON file path |
| aws | aws_profile | AWS profile name as set in the shared configuration and credentials files |
| aws | aws_config_path | AWS shared configuration file path |
| aws | aws_creds_path | AWS shared credentials file path |
| gcp | gcp_adc_path | GCP Application Default Credentials JSON file path |
| ibm-openshift | ibmc_key_path | IBM Cloud API Key JSON file path |


### CPU Architecture

CPU Architecture can be set to either `"x86"` or `"arm64"`

```bash
terraform apply -var 'cloud_provider=aws' -var 'cpu_arch=arm64'
```

Note: The `"ibm-openshift"` provider does not support ARM architecture. If set, any IBM OpenShift clusters will be destroyed

### Node count

The number of VMs running as Kubernetes nodes can be specified as

```bash
terraform apply -var 'cloud_provider=aws' -var 'node_count=2'
```

### Helm

Resurface can be deployed with cert-manager, or by itself

```bash
terraform apply -var 'cloud_provider=aws' -var 'helm_tls_enabled=true'
```

Both multinode and iceberg modes can be enabled/disabled

```bash
terraform apply -var 'cloud_provider=aws' -var 'helm_multinode_enabled=true' -var 'helm_iceberg_enabled=true'
```

Helm release installation can be skipped entirely (only create Kubernetes clusters)

```bash
terraform apply -var 'cloud_provider=aws' -var 'skip_helm=true'
```

For more variables, please take a look at the [reference](#variables)

## Modules

- `aks`: AKS cluster and minimum required infrastructure
    - `azurerm_resource_group`: Azure Resource Group
    - `azurerm_kubernetes_cluster`: AKS cluster
    - `azurerm_kubernetes_cluster_node_pool`: AKS node pool
    - `local_file`: AKS cluster kubeconfig file
- `eks`: EKS cluster and minimum required infrastructure
    - `aws_iam_role`: EKS Cluster Role, EKS Node Role
    - `aws_iam_role_policy_attachment`: Policies for each role
    - `aws_vpc`: AWS VPC
    - `aws_subnet`: 3 public AWS Subnets
    - `aws_internet_gateway`: AWS Internet Gateway
    - `aws_route_table`: AWS Route Table
    - `aws_route_table_association`: Associate Subnets with Internet Gateway
    - `aws_eks_cluster`: AWS EKS cluster
    - `aws_eks_node_group`: AWS EKS node group
    - `aws_eks_addon`: VPC CNI, Core DNS, EBS CSI
    - `local_file`: EKS cluster kubeconfig file
- `gke`: GKE cluster and minimum required infrastructure
    - `google_compute_network`: GCP VPC
    - `google_compute_subnetwork`: GCP Subnet
    - `google_container_cluster`: GKE cluster
    - `google_container_node_pool`: GKE node pool
- `ibm-oc`: IBM OpenShift cluster and minimum required infrastructure
    - `ibm_is_vpc`: IBM Cloud VPC
    - `ibm_is_public_gateway`:IBM Cloud Public Gateway
    - `ibm_is_subnet`: IBM Cloud Subnet
    - `ibm_resource_instance`: IBM Cloud COS instance
    - `ibm_container_vpc_cluster`: IBM OpenShift Cluster
- `helm`: helm releases
    - `helm_release`: Resurface, Cert-manager

## Variables

| Variable | Description | Type | Default value | Required | 
|---|---|---|---|---|---|
| `cloud_provider` | Cloud provider to deploy Kubernetes cluster" | `string` | `""` | No |
| `cloud_providers` | List of cloud providers to deploy Kubernetes clusters" | `list(string)` | `[]` | No |
| `cpu_arch` | CPU architecture for node pool VMs" | `string` | `"x86"` | `var.cpu_arch == "x86" || var.cpu_arch == "arm64"` | No |
| `node_count` | Number of Kubernetes nodes" | `number` | `1` | No |

### API Keys and Credentials

| Variable | Description | Type | Default value | Required |
|---|---|---|---|---|---|
| `azure_subscription_id` | Azure Subscription ID | `string` | | Yes |
| `azure_sp_path` | Azure Service Principal JSON file path | `string` | | Yes |
| `aws_profile` | AWS profile name as set in the shared configuration and credentials files | `string` | `"default"` | No |
| `aws_config_path` | AWS shared configuration file path | `string` | | Yes |
| `aws_creds_path` | AWS shared credentials file path | `string` | | Yes |
| `gcp_adc_path` | GCP Application Default Credentials JSON file path | `string` | | Yes |
| `ibmc_key_path` | IBM Cloud API Key JSON file path | `string` | | Yes |

### Resource Groups and Project IDs

| Variable | Description | Type | Default value | Required |
|---|---|---|---|---|---|
| `azure_resource_group` | Azure resource group | `string` | | Yes |
| `gcp_project_id` | GCP Project ID | `string` | | Yes |
| `ibmc_resource_group` | IBM Cloud resource group | `string` | | Yes |

### Regions and Zones

| Variable | Description | Type | Default value | Required |
|---|---|---|---|---|---|
| `azure_region` | Azure region" | `string` | `"East US 2"` | No |
| `azure_use_existing_rg` | Set to true to use existing Resource Group" | `bool` | `false` | No |
| `aws_region` | AWS region" | `string` | `"us-east-1"` | No |
| `aws_zones` | AWS availability zones | `list(string)` | `["us-east-1a", "us-east-1b", "us-east-1c"]` | `length(var.aws_zones) == 3` | No |
| `gcp_region` | GCP region" | `string` | `"us-central1"` | No |
| `gcp_zone` | GCP zone" | `string` | `"us-central1-a"` | No |
| `ibmc_region` | IBM Cloud region" | `string` | `"us-south"` | No |
| `ibmc_zone` | IBM Cloud zone" | `string` | `"us-south-1"` | No |

### Kubeconfig directories

| Variable | Description | Type | Default value | Required |
|---|---|---|---|---|---|
| `aks_kubeconfig_dir` | Directory path on your local machine where the AKS cluster configuration file will be downloaded to." | `string` | `"."` | No |
| `eks_kubeconfig_dir` | Directory path on your local machine where the EKS cluster configuration file will be downloaded to." | `string` | `"."` | No |
| `gke_kubeconfig_dir` | Directory path on your local machine where the GKE cluster configuration file will be downloaded to." | `string` | `"."` | No |
| `ibm_openshift_kubeconfig_dir` | Directory path on your local machine where the IBM OpenShift cluster configuration file will be downloaded to." | `string` | `"."` | No |

### Helm options

| Variable | Description | Type | Default value | Required |
|---|---|---|---|---|---|
| `helm_use_local_chart` | Set to true if using a helm local chart" | `bool` | `false` | No |
| `helm_local_chart_path` | Helm local chart directory path" | `string` | `"."` | No |
| `helm_timeout` | Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks)" | `number` | `300` | No |
| `skip_helm` | Set to true to skip all helm installs" | `bool` | `false` | No |
| `helm_multinode_enabled` | Set to true to enable multinode mode" | `bool` | `false` | No |
| `helm_multinode_worker_count` | Number of worker nodes" | `number` | `1` | No |
| `helm_iceberg_enabled` | Set to true to enable iceberg mode" | `bool` | `false` | No |
| `helm_tls_enabled` | Set to true to install cert-manager chart" | `bool` | `false` | No |
| `helm_tls_autoissue_email` | Let's encrypt notifications will be sent to this address" | `string` | `"foo@bar.com"` | No |
| `helm_auth_enabled` | Set to true to enable basic auth" | `bool` | `false` | No |
| `helm_cert_manager_chart_version` | Cert-manager chart version" | `string` | `"v1.14.4"` | No |
| `helm_resurface_chart_version` | Resurface chart version" | `string` | `""` | No |
| `helm_resurface_app_version` | Resurface chart version" | `string` | `""` | No |

### Hosts for TLS

| Variable | Description | Type | Default value | Required |
|---|---|---|---|---|---|
| `helm_tls_host_azure` | Host included in the TLS certificate for the Resurface AKS service" | `string` | `""` | No |
| `helm_tls_host_aws` | Host included in the TLS certificate for the Resurface EKS service" | `string` | `""` | No |
| `helm_tls_host_gcp` | Host included in the TLS certificate for the Resurface GKE service" | `string` | `""` | No |

### Miscellaneous

| Variable | Description | Type | Default value | Required |
|---|---|---|---|---|---|
| `prefix` | Prefix to use with all resources" | `string` | `"qa-"` | No |


## Outputs
