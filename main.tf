# ----------------------------------------------------------------------------------------------------------------------
# Module : Argo CD
# Dependencies :
#     - https://www.terraform.io/docs/providers/kubernetes/index.html
#     - https://github.com/banzaicloud/terraform-provider-k8s
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.13.0"

  required_providers {
    kubernetes = {
        source  = "hashicorp/kubernetes"
        version = "~> 1.13.0"
    }

    k8s = {
        source = "banzaicloud/k8s"
        version = "~> 0.8.3"
    }
  }
}

data "http" "install" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/v${var.argo_cd_version}/manifests/install.yaml"
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
# ArgoCD Resources
# ----------------------------------------------------------------------------------------------------------------------
locals {
  resources = split("\n---\n", data.http.install.body)
}

resource "k8s_manifest" "resource" {
  count = length(local.resources)

  namespace = var.namespace
  content   = local.resources[count.index]

  depends_on = [kubernetes_namespace.argo]
}
