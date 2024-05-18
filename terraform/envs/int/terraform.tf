################################
#       Backend Storage        #
################################
terraform {
  backend "gcs" {
    bucket = "hamzahllc-technical-task"
    prefix = "int"
  }

}


################################
#      Required Provider       #
################################
terraform {
  required_providers {
    kubectl = {
      source                = "gavinbunney/kubectl"
      version               = ">= 1.7.0"
      configuration_aliases = [kubectl.kctl]
    }
    kubernetes = {
      source                = "hashicorp/kubernetes"
      configuration_aliases = [kubernetes.k8s]
    }
    helm = {
      source = "hashicorp/helm"
      # version = ">= 2.4.1"
      configuration_aliases = [helm.helm]
    }
    godaddy-dns = {
      source = "registry.terraform.io/veksh/godaddy-dns"
    }
  }
}

################################
#       Google Provider        #
################################
provider "google" {
  project = "hamzahllc-technical-task"
  region  = "us-central1"
}

################################
#     Kubernetes Provider      #
################################
provider "kubernetes" {
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  host                   = module.gke_auth.host
  token                  = module.gke_auth.token
  alias                  = "k8s"
}

################################
#       Kubectl Provider       #
################################
provider "kubectl" {
  host                   = module.gke_auth.host
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  token                  = module.gke_auth.token
  load_config_file       = false
  alias                  = "kctl"
}

################################
#        Helm Provider         #
################################
provider "helm" {

  kubernetes {
    host                   = module.gke_auth.host
    client_key             = module.gke_auth.token
    cluster_ca_certificate = module.gke_auth.cluster_ca_certificate

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      # command     = "gke-gcloud-auth-plugin"
    }
  }
  alias = "helm"

}
################################
#       Godaddy Provider       #
################################
provider "godaddy-dns" {
  api_key    = "gHfBU537MdNg_81z8h3nRBLjUzMZvqcMB6W"
  api_secret = "TDKCmgryrCGcy6AW9wKKAo"
}
