resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.subnet_cidr
}

data "google_container_engine_versions" "gke_version" {
  location       = var.zone
  version_prefix = var.kube_version_prefix
}

resource "google_container_cluster" "cluster" {
  name     = "${var.project_id}-gke"
  location = var.zone

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  # deletion_protection = false
}

resource "google_container_node_pool" "cluster_nodes" {
  name     = "${google_container_cluster.cluster.name}-nodes"
  location = var.zone
  cluster  = google_container_cluster.cluster.name
  version  = data.google_container_engine_versions.gke_version.release_channel_default_version["REGULAR"]

  node_count = var.node_count
  node_config {
    machine_type = var.cpu_arch == "x86" ? "c3d-standard-8" : "t2a-standard-8"
    disk_size_gb = 10

    labels = {
      gcp-project-id = var.project_id
    }
    tags = ["gke-node", "${var.project_id}-gke"]
  }
}

data "google_client_config" "default" {}

resource "local_file" "cluster_config" {
  filename        = "${var.kube_config_path}/${google_container_cluster.cluster.name}-config.yml"
  file_permission = 600
  content         = <<EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}
    server: https://${google_container_cluster.cluster.endpoint}
  name: ${google_container_cluster.cluster.name}
contexts:
- context:
    cluster: ${google_container_cluster.cluster.name}
    user: ${google_container_cluster.cluster.name}
  name: ${google_container_cluster.cluster.name}
users:
- name: ${google_container_cluster.cluster.name}-token
  user:
    token: ${data.google_client_config.default.access_token}
- name: ${google_container_cluster.cluster.name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: gke-gcloud-auth-plugin
      provideClusterInfo: true
current-context: ${google_container_cluster.cluster.name}
kind: Config
preferences: {}
EOT
}
