################################
#         GKE Service          #
################################
resource "google_project_service" "gke" {
  project            = var.project_id
  service            = "container.googleapis.com"
  disable_on_destroy = true
}

################################
#      GKE ServiceAccount      #
################################
module "service_account" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 3.0"
  project_id = var.project_id
  names      = ["${var.name}-${var.env}-sa"]
  project_roles = [
    "${var.project_id}=>roles/artifactregistry.reader"
  ]
}

################################
#          GKE Module          #
################################
module "gke" {
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                         = "30.3.0"
  project_id                      = var.project_id
  name                            = var.name
  region                          = var.region
  zones                           = ["${var.zone}"]
  network                         = var.vpc_name
  regional                        = false
  master_ipv4_cidr_block          = var.master_node_cidr
  subnetwork                      = var.subnet_name
  ip_range_pods                   = var.subnet_cidr_sec1
  ip_range_services               = var.subnet_cidr_sec2
  kubernetes_version              = "1.27.11-gke.1062001"
  release_channel                 = "UNSPECIFIED"
  create_service_account          = false
  http_load_balancing             = true
  remove_default_node_pool        = true
  network_policy                  = true
  horizontal_pod_autoscaling      = false
  enable_vertical_pod_autoscaling = false
  enable_private_nodes            = true
  enable_private_endpoint         = false
  master_authorized_networks      = var.master_authorized_networks
  filestore_csi_driver            = false
  deletion_protection             = false
  service_account                 = module.service_account.email
  node_pools                      = var.node_pools
  depends_on                      = [google_project_service.gke]
}