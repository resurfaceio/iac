provider "helm" {
  kubernetes {
    host                   = contains(["basic", "token"], var.kube_config_source) ? var.kube_config.host : null
    cluster_ca_certificate = contains(["basic", "token"], var.kube_config_source) ? base64decode(var.kube_config.ca_cert) : null
    username               = contains(["basic", "token"], var.kube_config_source) ? var.kube_config.username : null
    password               = contains(["basic"], var.kube_config_source) ? var.kube_config.password : null
    token                  = contains(["token"], var.kube_config_source) ? var.kube_config.token : null
    client_certificate     = contains(["basic", "token"], var.kube_config_source) ? base64decode(var.kube_config.client_cert) : null
    client_key             = contains(["basic", "token"], var.kube_config_source) ? base64decode(var.kube_config.client_key) : null
    config_path            = var.kube_config_source == "file" ? var.kube_config_path : null
  }
}

locals {
  namespace = "resurface"
}

resource "helm_release" "cert-manager" {
  count      = var.skip_release || !var.tls_enabled || var.cloud_provider == "ibm-openshift" ? 0 : 1
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  name             = "cert-manager"
  namespace        = local.namespace
  create_namespace = true
  version          = var.cert_manager_version
  timeout          = var.timeout

  values = [var.cloud_provider == "gcp" ? "${file("./modules/helm/cert-manager-values.yml")}" : ""]

  set {
    name  = "installCRDs"
    value = true
  }
  set {
    name  = "prometheus.enabled"
    value = false
  }
}

resource "helm_release" "resurface" {
  count      = var.skip_release ? 0 : 1
  depends_on = [helm_release.cert-manager]

  repository = !var.is_local_chart ? "https://resurfaceio.github.io/containers" : null
  chart      = !var.is_local_chart ? "resurface" : var.local_chart_path
  version    = !var.is_local_chart ? var.resurface_chart_version : null

  name                  = "resurface"
  namespace             = local.namespace
  create_namespace      = true
  render_subchart_notes = true
  timeout               = var.timeout

  set {
    name  = "custom.config.version"
    value = var.resurface_app_version
  }

  set {
    name  = "provider"
    value = var.cloud_provider
  }

  set {
    name  = "multinode.enabled"
    value = var.multinode_enabled
  }

  set {
    name  = "multinode.workers"
    value = var.worker_count
  }

  set {
    name  = "ingress.controller.enabled"
    value = var.cloud_provider != "ibm-openshift"
  }

  set {
    name  = "iceberg.enabled"
    value = var.iceberg_enabled
  }

  set {
    name  = "minio.enabled"
    value = var.iceberg_enabled
  }

  set_sensitive {
    name  = "minio.rootUser"
    value = "minio"
  }

  set_sensitive {
    name  = "minio.rootPassword"
    value = "minio123"
  }

  set {
    name = "ingress.minio.expose"
    value = true
  }

  set {
    name  = "ingress.tls.host"
    value = var.tls_enabled || var.cloud_provider == "ibm-openshift" ? var.tls_host : ""
  }

  set {
    name  = "ingress.tls.enabled"
    value = var.cloud_provider != "ibm-openshift" && var.tls_enabled && var.tls_host != ""
  }

  set {
    name  = "ingress.tls.autoissue.enabled"
    value = true
  }

  set_sensitive {
    name  = "ingress.tls.autoissue.email"
    value = var.tls_autoissue_email
  }

  set {
    name = "auth.enabled"
    value = var.auth_enabled
  }

    set {
    name = "auth.basic.enabled"
    value = var.auth_enabled
  }

  set_sensitive {
    name = "auth.basic.credentials[0].username"
    value = "rob"
  }

  set_sensitive {
    name = "auth.basic.credentials[0].password"
    value = "blah1234"
  }
}
