################################
#         VPC Resource         #
################################
resource "google_compute_network" "vpc" {
  name                    = "${var.vpc_name}"
  auto_create_subnetworks = false
  project                 = var.project_id
}

################################
#       Subnets Resource       #
################################
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  secondary_ip_range {
    range_name    = "${var.app}-${var.env}-subnet-sec1"
    ip_cidr_range = var.subnet_cidr_sec1
  }
  secondary_ip_range {
    range_name    = "${var.app}-${var.env}-subnet-sec2"
    ip_cidr_range = var.subnet_cidr_sec2
  }
}


################################
#       Router Resource        #
################################
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.app}-${var.env}-router"
  network = google_compute_network.vpc.name
  region  = var.region
}

################################
#         NAT Resource         #
################################
resource "google_compute_router_nat" "nat" {
  name                               = "${var.app}-${var.env}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = false
    filter = "ERRORS_ONLY"
  }
}

################################
#      Firewall Resource       #
################################
resource "google_compute_firewall" "firewall" {
  project   = var.project_id
  name      = "allow-iap"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_tags   = null
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-iap"]
}

