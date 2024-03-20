# Graylog API Security on IBM OpenShift Cluster

## Resources

- VPC
- Public Gateway
- Subnet
- Cloud Object Storage
- OpenShift Cluster
- kubeconfig file


## Variables

- `prefix`: Prefix to use with all resources
- `zone`: IBM Cloud zone
- `resource_group`: IBM Cloud resource group
- `openshift_version`: Version of IBM Cloud OpenShift
- `openshift_vm_type`: VM type for IBM Cloud OpenShift worker nodes
- `openshift_pool_size`: Number of IBM Cloud OpenShift workers
- `config_is_admin`: Download the TLS certificates and permission files for the Super User cluster role.
- `kube_config_path`: Directory path on your local machine where the cluster configuration file will be downloaded to.


## Outputs

- `cluster_name`: The name of the cluster.
- `cluster_status`: The state of the cluster master.
- `cluster_ingress_hostname`: The hostname of the cluster ingress resource.
- `cluster_config_ctx`: Context for the cluster configuration.
- `cluster_config_file`: The path on your local machine where the cluster configuration file and certificates are downloaded to.
