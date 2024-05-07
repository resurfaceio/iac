data "ibm_resource_group" "group" {
  name = var.resource_group
}

resource "ibm_is_vpc" "vpc" {
  name           = "${var.prefix}vpc"
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_public_gateway" "public_gw" {
  name           = "${var.prefix}gateway-${var.zone}"
  resource_group = data.ibm_resource_group.group.id

  vpc  = ibm_is_vpc.vpc.id
  zone = var.zone
}

resource "ibm_is_subnet" "subnet" {
  name           = "${var.prefix}subnet"
  resource_group = data.ibm_resource_group.group.id

  vpc  = ibm_is_vpc.vpc.id
  zone = var.zone

  total_ipv4_address_count = 256
  public_gateway           = ibm_is_public_gateway.public_gw.id
}

resource "ibm_resource_instance" "cos" {
  name              = "${ibm_is_vpc.vpc.name}-cos"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = data.ibm_resource_group.group.id
}

resource "ibm_container_vpc_cluster" "cluster" {
  name              = "${ibm_is_vpc.vpc.name}-cluster"
  resource_group_id = data.ibm_resource_group.group.id

  vpc_id = ibm_is_vpc.vpc.id
  zones {
    subnet_id = ibm_is_subnet.subnet.id
    name      = var.zone
  }
  cos_instance_crn = ibm_resource_instance.cos.id

  flavor       = var.openshift_vm_type
  kube_version = var.openshift_version
  worker_count = var.openshift_pool_size

  force_delete_storage = true
  wait_till = "OneWorkerNodeReady"
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = ibm_container_vpc_cluster.cluster.id
  admin           = var.config_is_admin
  config_dir      = var.kube_config_path
  # download        = false
}

# resource "local_file" "cluster_config" {
#   filename        = "${var.config_path}/${ibm_container_vpc_cluster.cluster.name}-config.yml"
#   file_permission = 600
#   content         = <<EOT
# apiVersion: v1
# clusters:
# - cluster:
#     certificate-authority-data: ${data.ibm_container_cluster_config.cluster_config.ca_certificate}
#     server: https://${data.ibm_container_cluster_config.cluster_config.endpoint_type}
#   name: ${ibm_container_vpc_cluster.cluster.name}/${ibm_container_vpc_cluster.cluster.id}
# contexts:
# - context:
#     cluster: ${ibm_container_vpc_cluster.cluster.name}/${ibm_container_vpc_cluster.cluster.id}
#     user: ${ibm_container_vpc_cluster.cluster.name}
#   name: ${ibm_container_vpc_cluster.cluster.name}/${ibm_container_vpc_cluster.cluster.id}
# users:
# - name: ${ibm_container_vpc_cluster.cluster.name}
#   user:
#     token: ${data.ibm_container_cluster_config.cluster_config.token}
# - name: ${ibm_container_vpc_cluster.cluster.name}
#   user:
#     client-certificate-data: ${data.ibm_container_cluster_config.cluster_config.admin_certificate}
#     client-key-data: ${data.ibm_container_cluster_config.cluster_config.admin_key}
# current-context: ${ibm_container_vpc_cluster.cluster.name}/${ibm_container_vpc_cluster.cluster.id}
# kind: Config
# preferences: {}
# EOT
# }
