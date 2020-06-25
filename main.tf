# ----------------------------------------------------------------------------------------------------------------------
# Module : Argo CD
# Dependencies :
#     - https://www.terraform.io/docs/providers/kubernetes/index.html
#     - https://github.com/banzaicloud/terraform-provider-k8s
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.0"
  required_providers {
    kubernetes = ">= 1.11.0"
    k8s        = ">= 0.7.6"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Namespaces
# ----------------------------------------------------------------------------------------------------------------------
resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# CRDs
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "crd_argo_application" {
  template = file("manifests/${var.version}/crds/argo-application-crd.yaml")
}

resource "k8s_manifest" "nginx-crd_argo_application" {
  content = data.template_file.crd_argo_application.rendered
}

data "template_file" "crd_argo_project" {
  template = file("manifests/${var.version}/crds/argo-project-crd.yaml")
}

resource "k8s_manifest" "crd_argo_project" {
  content = data.template_file.crd_argo_project.rendered
}

# ----------------------------------------------------------------------------------------------------------------------
# Cluster Roles
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "cluster_role_argocd_application_controller" {
  template = file("manifests/${var.version}/cluster-role/argocd-application-controller.yaml")
}

resource "k8s_manifest" "cluster_role_argocd_application_controller" {
  content = data.template_file.cluster_role_argocd_application_controller.rendered
}

data "template_file" "cluster_role_argocd_server" {
  template = file("manifests/${var.version}/cluster-role/argocd-server.yaml")
}

resource "k8s_manifest" "cluster_role_argocd_server" {
  content = data.template_file.cluster_role_argocd_server.rendered
}

# ----------------------------------------------------------------------------------------------------------------------
# Cluster Role Bindings
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "cluster_role_binding_argocd_application_controller" {
  template = file("manifests/${var.version}/cluster-role-bindings/argocd-application-controller.yaml")
}

resource "k8s_manifest" "cluster_role_binding_argocd_application_controller" {
  content = data.template_file.cluster_role_binding_argocd_application_controller.rendered
}

data "template_file" "cluster_role_binding_argocd_server" {
  template = file("manifests/${var.version}/cluster-role-bindings/argocd-server.yaml")
}

resource "k8s_manifest" "cluster_role_binding_argocd_server" {
  content = data.template_file.cluster_role_binding_argocd_server.rendered
}

# ----------------------------------------------------------------------------------------------------------------------
# Roles
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "role_argocd_application_controller" {
  template = file("manifests/${var.version}/roles/argocd-application-controller.yaml")
}

resource "k8s_manifest" "role_argocd_application_controller" {
  content   = data.template_file.role_argocd_application_controller.rendered
  namespace = var.namespace
}

data "template_file" "role_argocd_dex_server" {
  template = file("manifests/${var.version}/roles/argocd-dex-server.yaml")
}

resource "k8s_manifest" "role_argocd_dex_server" {
  content   = data.template_file.role_argocd_dex_server.rendered
  namespace = var.namespace
}

data "template_file" "role_server_role" {
  template = file("manifests/${var.version}/roles/server-role.yaml")
}

resource "k8s_manifest" "role_server_role" {
  content   = data.template_file.role_server_role.rendered
  namespace = var.namespace
}

# ----------------------------------------------------------------------------------------------------------------------
# Role Bindings
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "role_binding_argocd_application_controller" {
  template = file("manifests/${var.version}/role-bindings/argocd-application-controller.yaml")
}

resource "k8s_manifest" "role_binding_argocd_application_controller" {
  content   = data.template_file.role_binding_argocd_application_controller.rendered
  namespace = var.namespace
}

data "template_file" "role_binding_argocd_dex_server" {
  template = file("manifests/${var.version}/role-bindings/argocd-dex-server.yaml")
}

resource "k8s_manifest" "role_binding_argocd_dex_server" {
  content   = data.template_file.role_binding_argocd_dex_server.rendered
  namespace = var.namespace
}

data "template_file" "role_binding_argocd_server" {
  template = file("manifests/${var.version}/role-bindings/argocd-server.yaml")
}

resource "k8s_manifest" "role_binding_argocd_server" {
  content   = data.template_file.role_binding_argocd_server.rendered
  namespace = var.namespace
}

# ----------------------------------------------------------------------------------------------------------------------
# Service Accounts
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "service_account_argocd_application_controller" {
  template = file("manifests/${var.version}/service-accounts/argocd-application-controller.yaml")
}

resource "k8s_manifest" "service_account_argocd_application_controller" {
  content   = data.template_file.service_account_argocd_application_controller.rendered
  namespace = var.namespace
}

data "template_file" "service_account_argocd_dex_server" {
  template = file("manifests/${var.version}/service-accounts/argocd-dex-server.yaml")
}

resource "k8s_manifest" "service_account_argocd_dex_server" {
  content   = data.template_file.service_account_argocd_dex_server.rendered
  namespace = var.namespace
}

data "template_file" "service_account_argocd_server" {
  template = file("manifests/${var.version}/service-accounts/argocd-server.yaml")
}

resource "k8s_manifest" "service_account_argocd_server" {
  content   = data.template_file.service_account_argocd_server.rendered
  namespace = var.namespace
}

# ----------------------------------------------------------------------------------------------------------------------
# ConfigMaps
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "configmap_argocd_cm" {
  template = file("manifests/${var.version}/configmaps/argocd-cm.yaml")
}

resource "k8s_manifest" "configmap_argocd_cm" {
  content   = data.template_file.configmap_argocd_cm.rendered
  namespace = var.namespace
}

data "template_file" "configmap_argocd_rbac_cm" {
  template = file("manifests/${var.version}/configmaps/argocd-rbac-cm.yaml")
}

resource "k8s_manifest" "configmap_argocd_rbac_cm" {
  content   = data.template_file.configmap_argocd_rbac_cm.rendered
  namespace = var.namespace
}

data "template_file" "configmap_argocd_ssh_known_hosts_cm" {
  template = file("manifests/${var.version}/configmaps/argocd-ssh-known-hosts-cm.yaml")
}

resource "k8s_manifest" "configmap_argocd_ssh_known_hosts_cm" {
  content   = data.template_file.configmap_argocd_ssh_known_hosts_cm.rendered
  namespace = var.namespace
}

data "template_file" "configmap_argocd_tls_certs_cm" {
  template = file("manifests/${var.version}/configmaps/argocd-tls-certs-cm.yaml")
}

resource "k8s_manifest" "configmap_argocd_tls_certs_cm" {
  content   = data.template_file.configmap_argocd_tls_certs_cm.rendered
  namespace = var.namespace
}

# ----------------------------------------------------------------------------------------------------------------------
# Secrets
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "secret_argocd_server" {
  template = file("manifests/${var.version}/secrets/argocd-server.yaml")
}

resource "k8s_manifest" "secret_argocd_server" {
  content   = data.template_file.secret_argocd_server.rendered
  namespace = var.namespace
}

# ----------------------------------------------------------------------------------------------------------------------
# Deployments
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "secret_argocd_application_controller" {
  template = file("manifests/${var.version}/deployments/argocd-application-controller.yaml")
}

resource "k8s_manifest" "secret_argocd_application_controller" {
  content   = data.template_file.secret_argocd_application_controller.rendered
  namespace = var.namespace
}

data "template_file" "secret_argocd_dex_server" {
  template = file("manifests/${var.version}/deployments/argocd-dex-server.yaml")
}

resource "k8s_manifest" "secret_argocd_dex_server" {
  content   = data.template_file.secret_argocd_dex_server.rendered
  namespace = var.namespace
}

data "template_file" "secret_argocd_redis" {
  template = file("manifests/${var.version}/deployments/argocd-redis.yaml")
}

resource "k8s_manifest" "secret_argocd_redis" {
  content   = data.template_file.secret_argocd_redis.rendered
  namespace = var.namespace
}

data "template_file" "secret_argocd_repo_server" {
  template = file("manifests/${var.version}/deployments/argocd-repo-server.yaml")
}

resource "k8s_manifest" "secret_argocd_repo_server" {
  content   = data.template_file.secret_argocd_repo_server.rendered
  namespace = var.namespace
}

data "template_file" "secret_argocd_server" {
  template = file("manifests/${var.version}/deployments/argocd-server.yaml")
}

resource "k8s_manifest" "secret_argocd_server" {
  content   = data.template_file.secret_argocd_server.rendered
  namespace = var.namespace
}

# ----------------------------------------------------------------------------------------------------------------------
# Services
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "service_argocd_dex_server" {
  template = file("manifests/${var.version}/services/argocd-dex-server.yaml")
}

resource "k8s_manifest" "service_argocd_dex_server" {
  content   = data.template_file.service_argocd_dex_server.rendered
  namespace = var.namespace
}

data "template_file" "service_argocd_metrics" {
  template = file("manifests/${var.version}/services/argocd-metrics.yaml")
}

resource "k8s_manifest" "service_argocd_metrics" {
  content   = data.template_file.service_argocd_metrics.rendered
  namespace = var.namespace
}

data "template_file" "service_argocd_redis" {
  template = file("manifests/${var.version}/services/argocd-redis.yaml")
}

resource "k8s_manifest" "service_argocd_redis" {
  content   = data.template_file.service_argocd_redis.rendered
  namespace = var.namespace
}

data "template_file" "service_argocd_repo_server" {
  template = file("manifests/${var.version}/services/argocd-repo-server.yaml")
}

resource "k8s_manifest" "service_argocd_repo_server" {
  content   = data.template_file.service_argocd_repo_server.rendered
  namespace = var.namespace
}

data "template_file" "service_argocd_server" {
  template = file("manifests/${var.version}/services/argocd-server.yaml")
}

resource "k8s_manifest" "service_argocd_server" {
  content   = data.template_file.service_argocd_server.rendered
  namespace = var.namespace
}

data "template_file" "service_argocd_server_metrics" {
  template = file("manifests/${var.version}/services/argocd-server-metrics.yaml")
}

resource "k8s_manifest" "service_argocd_server_metrics" {
  content   = data.template_file.service_argocd_server_metrics.rendered
  namespace = var.namespace
}