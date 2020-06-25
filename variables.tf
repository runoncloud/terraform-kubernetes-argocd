variable "argo_cd_version" {
  description = "The version of Argo CD."
  type        = string
  default     = "1.5.5"
}

variable "namespace" {
  description = "The namespace in which Argo CD will be deployed."
  type        = string
  default     = "argocd"
}