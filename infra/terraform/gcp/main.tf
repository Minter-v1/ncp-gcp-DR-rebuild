// MARK: - GCP Standby Network

module "network" {
  source = "./modules/network"

  resource_prefix      = var.resource_prefix
  region               = var.region
  gke_subnet_cidr      = var.gke_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
  gke_pod_cidr         = var.gke_pod_cidr
  gke_service_cidr     = var.gke_service_cidr
}

// MARK: - GKE Warm Standby

module "gke" {
  source = "./modules/gke"

  project_id             = var.project_id
  resource_prefix        = var.resource_prefix
  region                 = var.region
  network_id             = module.network.network_id
  gke_subnetwork_id      = module.network.gke_subnetwork_id
  gke_pod_range_name     = module.network.gke_pod_range_name
  gke_service_range_name = module.network.gke_service_range_name
  node_locations         = var.gke_node_locations
  machine_type           = var.gke_machine_type
  min_node_count         = var.gke_min_node_count
  max_node_count         = var.gke_max_node_count
  master_ipv4_cidr_block = var.gke_master_cidr
}