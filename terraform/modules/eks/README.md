# Graylog API Security on Elastic Kubernetes Service

## Resources

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

## Variables

- `prefix"`: Prefix to use with all resources
- `region"`: AWS region
- `availability_zones"`: AWS availability zones
- `vpc_cidr"`: CIDR for new AWS VPC
- `subnet_cidrs"`: CIDRs for new AWS Subnets
- `node_count"`: Number of EKS nodes
- `kube_version"`: EKS Version
- `cpu_arch"`: CPU architecture for node pool VMs
- `kube_config_path"`: Directory path on your local machine where the cluster configuration file will be downloaded to

## Outputs

- `cluster_name`: EKS cluster name
- `cluster_arn`: EKS cluster ARN
- `cluster_config_file`: EKS cluster config yaml file location