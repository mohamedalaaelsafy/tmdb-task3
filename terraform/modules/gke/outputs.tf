################################
#       GKE Module Outputs     #
################################
output "cluster_name" {
  value = module.gke.name
}

output "cluster_ca_certificate" {
  value = base64decode(module.gke.ca_certificate)
}

output "cluster_gke_endpoint" {
  value = module.gke.endpoint
}

