# ----------------------------------------------------------------------------------------------------------------------
# Module : Argo CD
# Dependencies :
#     - https://www.terraform.io/docs/providers/kubernetes/index.html
#     - https://github.com/banzaicloud/terraform-provider-k8s
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.24"
  required_providers {
    kubernetes = ">= 1.11.0"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Namespaces
# ----------------------------------------------------------------------------------------------------------------------
resource "kubernetes_namespace" "argo" {
  metadata {
    name = var.namespace
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# CRDs
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "crd_argo_application" {
  template = file("manifests/${var.argo_cd_version}/crds/argo-application-crd.yml")
}

resource "k8s_manifest" "crd_argo_application" {
  content = data.template_file.crd_argo_application.rendered
}

data "template_file" "crd_argo_project" {
  template = file("manifests/${var.argo_cd_version}/crds/argo-project-crd.yml")
}

resource "k8s_manifest" "crd_argo_project" {
  content = data.template_file.crd_argo_project.rendered
}

# ----------------------------------------------------------------------------------------------------------------------
# Cluster Roles
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "cluster_role_argocd_application_controller" {
  template = file("manifests/${var.argo_cd_version}/cluster-roles/argocd-application-controller.yml")
}

resource "k8s_manifest" "cluster_role_argocd_application_controller" {
  content = data.template_file.cluster_role_argocd_application_controller.rendered
}

data "template_file" "cluster_role_argocd_server" {
  template = file("manifests/${var.argo_cd_version}/cluster-roles/argocd-server.yml")
}

resource "k8s_manifest" "cluster_role_argocd_server" {
  content = data.template_file.cluster_role_argocd_server.rendered
}

# ----------------------------------------------------------------------------------------------------------------------
# Cluster Role Bindings
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "cluster_role_binding_argocd_application_controller" {
  template = file("manifests/${var.argo_cd_version}/cluster-role-bindings/argocd-application-controller.yml")
}

resource "k8s_manifest" "cluster_role_binding_argocd_application_controller" {
  content = data.template_file.cluster_role_binding_argocd_application_controller.rendered
}

data "template_file" "cluster_role_binding_argocd_server" {
  template = file("manifests/${var.argo_cd_version}/cluster-role-bindings/argocd-server.yml")
}

resource "k8s_manifest" "cluster_role_binding_argocd_server" {
  content = data.template_file.cluster_role_binding_argocd_server.rendered
}

# ----------------------------------------------------------------------------------------------------------------------
# Roles
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "role_argocd_application_controller" {
  template = file("manifests/${var.argo_cd_version}/roles/argocd-application-controller.yml")
}

resource "k8s_manifest" "role_argocd_application_controller" {
  content    = data.template_file.role_argocd_application_controller.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "role_argocd_dex_server" {
  template = file("manifests/${var.argo_cd_version}/roles/argocd-dex-server.yml")
}

resource "k8s_manifest" "role_argocd_dex_server" {
  content    = data.template_file.role_argocd_dex_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "role_server_role" {
  template = file("manifests/${var.argo_cd_version}/roles/server-role.yml")
}

resource "k8s_manifest" "role_server_role" {
  content    = data.template_file.role_server_role.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

# ----------------------------------------------------------------------------------------------------------------------
# Role Bindings
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "role_binding_argocd_application_controller" {
  template = file("manifests/${var.argo_cd_version}/role-bindings/argocd-application-controller.yml")
}

resource "k8s_manifest" "role_binding_argocd_application_controller" {
  content    = data.template_file.role_binding_argocd_application_controller.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "role_binding_argocd_dex_server" {
  template = file("manifests/${var.argo_cd_version}/role-bindings/argocd-dex-server.yml")
}

resource "k8s_manifest" "role_binding_argocd_dex_server" {
  content    = data.template_file.role_binding_argocd_dex_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "role_binding_argocd_server" {
  template = file("manifests/${var.argo_cd_version}/role-bindings/argocd-server.yml")
}

resource "k8s_manifest" "role_binding_argocd_server" {
  content    = data.template_file.role_binding_argocd_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

# ----------------------------------------------------------------------------------------------------------------------
# Service Accounts
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "service_account_argocd_application_controller" {
  template = file("manifests/${var.argo_cd_version}/service-accounts/argocd-application-controller.yml")
}

resource "k8s_manifest" "service_account_argocd_application_controller" {
  content    = data.template_file.service_account_argocd_application_controller.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "service_account_argocd_dex_server" {
  template = file("manifests/${var.argo_cd_version}/service-accounts/argocd-dex-server.yml")
}

resource "k8s_manifest" "service_account_argocd_dex_server" {
  content    = data.template_file.service_account_argocd_dex_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "service_account_argocd_server" {
  template = file("manifests/${var.argo_cd_version}/service-accounts/argocd-server.yml")
}

resource "k8s_manifest" "service_account_argocd_server" {
  content    = data.template_file.service_account_argocd_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

# ----------------------------------------------------------------------------------------------------------------------
# ConfigMaps
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "configmap_argocd_cm" {
  template = file("manifests/${var.argo_cd_version}/configmaps/argocd-cm.yml")
}

resource "k8s_manifest" "configmap_argocd_cm" {
  content    = data.template_file.configmap_argocd_cm.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "configmap_argocd_rbac_cm" {
  template = file("manifests/${var.argo_cd_version}/configmaps/argocd-rbac-cm.yml")
}

resource "k8s_manifest" "configmap_argocd_rbac_cm" {
  content    = data.template_file.configmap_argocd_rbac_cm.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "configmap_argocd_ssh_known_hosts_cm" {
  template = file("manifests/${var.argo_cd_version}/configmaps/argocd-ssh-known-hosts-cm.yml")
}

resource "k8s_manifest" "configmap_argocd_ssh_known_hosts_cm" {
  content    = data.template_file.configmap_argocd_ssh_known_hosts_cm.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "configmap_argocd_tls_certs_cm" {
  template = file("manifests/${var.argo_cd_version}/configmaps/argocd-tls-certs-cm.yml")
}

resource "k8s_manifest" "configmap_argocd_tls_certs_cm" {
  content    = data.template_file.configmap_argocd_tls_certs_cm.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

# ----------------------------------------------------------------------------------------------------------------------
# Secrets
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "secret_argocd_server" {
  template = file("manifests/${var.argo_cd_version}/secrets/argocd-server.yml")
}

resource "k8s_manifest" "secret_argocd_server" {
  content    = data.template_file.secret_argocd_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

# ----------------------------------------------------------------------------------------------------------------------
# Deployments
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "deployment_argocd_application_controller" {
  template = file("manifests/${var.argo_cd_version}/deployments/argocd-application-controller.yml")
}

resource "k8s_manifest" "deployment_argocd_application_controller" {
  content    = data.template_file.deployment_argocd_application_controller.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "deployment_argocd_dex_server" {
  template = file("manifests/${var.argo_cd_version}/deployments/argocd-dex-server.yml")
}

resource "k8s_manifest" "deployment_argocd_dex_server" {
  content    = data.template_file.deployment_argocd_dex_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "deployment_argocd_redis" {
  template = file("manifests/${var.argo_cd_version}/deployments/argocd-redis.yml")
}

resource "k8s_manifest" "deployment_argocd_redis" {
  content    = data.template_file.deployment_argocd_redis.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "deployment_argocd_repo_server" {
  template = file("manifests/${var.argo_cd_version}/deployments/argocd-repo-server.yml")
}

resource "k8s_manifest" "deployment_argocd_repo_server" {
  content    = data.template_file.deployment_argocd_repo_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "deployment_argocd_server" {
  template = file("manifests/${var.argo_cd_version}/deployments/argocd-server.yml")
}

resource "k8s_manifest" "deployment_argocd_server" {
  content    = data.template_file.deployment_argocd_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

# ----------------------------------------------------------------------------------------------------------------------
# Services
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "service_argocd_dex_server" {
  template = file("manifests/${var.argo_cd_version}/services/argocd-dex-server.yml")
}

resource "k8s_manifest" "service_argocd_dex_server" {
  content    = data.template_file.service_argocd_dex_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "service_argocd_metrics" {
  template = file("manifests/${var.argo_cd_version}/services/argocd-metrics.yml")
}

resource "k8s_manifest" "service_argocd_metrics" {
  content    = data.template_file.service_argocd_metrics.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "service_argocd_redis" {
  template = file("manifests/${var.argo_cd_version}/services/argocd-redis.yml")
}

resource "k8s_manifest" "service_argocd_redis" {
  content    = data.template_file.service_argocd_redis.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "service_argocd_repo_server" {
  template = file("manifests/${var.argo_cd_version}/services/argocd-repo-server.yml")
}

resource "k8s_manifest" "service_argocd_repo_server" {
  content    = data.template_file.service_argocd_repo_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "service_argocd_server" {
  template = file("manifests/${var.argo_cd_version}/services/argocd-server.yml")
}

resource "k8s_manifest" "service_argocd_server" {
  content    = data.template_file.service_argocd_server.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}

data "template_file" "service_argocd_server_metrics" {
  template = file("manifests/${var.argo_cd_version}/services/argocd-server-metrics.yml")
}

resource "k8s_manifest" "service_argocd_server_metrics" {
  content    = data.template_file.service_argocd_server_metrics.rendered
  namespace  = var.namespace
  depends_on = [kubernetes_namespace.argo]
}