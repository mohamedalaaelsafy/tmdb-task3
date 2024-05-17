################################
#      Required Provider       #
################################
terraform {
  required_providers {
    kubectl = {
      source                = "gavinbunney/kubectl"
      version               = ">= 1.7.0"
      configuration_aliases = [kubectl]
    }
    kubernetes = {
      source                = "hashicorp/kubernetes"
      configuration_aliases = [kubernetes]
    }
    helm = {
      source                = "hashicorp/helm"
      version               = ">= 2.4.1"
      configuration_aliases = [helm]
    }
  }
}