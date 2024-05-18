################################
#        Network Module        #
################################
module "network" {
  source           = "../../modules/network"
  project_id       = var.project_id
  env              = var.env
  region           = var.region
  zone             = var.zone
  app              = var.app
  vpc_name         = "${var.app}-${var.env}-vpc"
  subnet_name      = "${var.app}-${var.env}-subnet"
  subnet_cidr      = "10.0.1.0/24"
  subnet_cidr_sec1 = "10.1.0.0/16"
  subnet_cidr_sec2 = "10.2.0.0/16"
}

###############################
#         GKE Module          #
###############################
module "gke" {
  source                     = "../../modules/gke"
  project_id                 = var.project_id
  env                        = var.env
  region                     = var.region
  zone                       = var.zone
  app                        = var.app
  subnet_name                = module.network.subnet_name
  vpc_name                   = module.network.vpc_name
  name                       = "${var.app}-${var.env}-cluster"
  master_node_cidr           = "172.16.0.16/28"
  subnet_cidr_sec1           = module.network.subnet_cidr_sec1
  subnet_cidr_sec2           = module.network.subnet_cidr_sec2
  node_locations             = var.zone
  master_authorized_networks = [{ cidr_block = "0.0.0.0/0", display_name = "Allow all" }]
  node_pools = [
    {
      name            = "tmdb-pool"
      machine_type    = "e2-standard-2"
      node_locations  = var.zone
      min_count       = 1
      max_count       = 1
      spot            = false
      disk_size_gb    = 30
      disk_type       = "pd-standard"
      image_type      = "COS_CONTAINERD"
      logging_variant = "DEFAULT"
      auto_repair     = true
      auto_upgrade    = true
      # service_account             = module.service_account.email
      preemptible        = false
      initial_node_count = 1
    }
  ]

}


################################
#       GKE Auth Module        #
################################
module "gke_auth" {
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id           = var.project_id
  cluster_name         = module.gke.cluster_name
  location             = var.zone
  use_private_endpoint = false
  depends_on           = [module.gke]
}


################################
#     K8s Resources Module     #
################################
module "k8s-resources" {
  source = "../../modules/k8s-resources"
  providers = {
    kubectl    = kubectl.kctl
    kubernetes = kubernetes.k8s
    helm       = helm.helm
  }

  project_id = var.project_id
  env        = var.env
  region     = var.region
  app        = var.app

  install_namespaces = true
  namespaces         = ["int"]

  install_argocd   = true
  argocd_version   = "5.24.0"
  argocd_namespace = "argocd"
  argocd_project   = ""
  argocd_app       = "k8s-manifest/argocd/argocd-app.yaml"
  argocd_cm        = "k8s-manifest/argocd/argocd-cm.yaml"
  argocd_secret    = ""
  argocd_set_vars  = []


  install_ingress  = true
  ingress_version  = "4.0.17"
  ingress_set_vars = []

  ingress_argocd_file = "k8s-manifest/argocd/ingress.yaml"

  depends_on = [module.gke_auth]
}
