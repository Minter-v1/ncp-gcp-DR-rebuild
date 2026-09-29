// MARK: - GCP Network

output "network_id" {
  description = "Identifier of the GCP standby VPC"
  value       = module.network.network_id
}

output "network_name" {
  description = "Name of the GCP standby VPC"
  value       = module.network.network_name
}

output "gke_subnetwork_id" {
  description = "Identifier of the GKE subnetwork"
  value       = module.network.gke_subnetwork_id
}

output "database_subnetwork_id" {
  description = "Identifier of the standby database subnetwork"
  value       = module.network.database_subnetwork_id
}

output "gke_pod_range_name" {
  description = "Name of the GKE pod secondary range"
  value       = module.network.gke_pod_range_name
}

output "gke_service_range_name" {
  description = "Name of the GKE service secondary range"
  value       = module.network.gke_service_range_name
}

output "cloud_router_name" {
  description = "Name of the Cloud Router"
  value       = module.network.router_name
}

output "cloud_nat_name" {
  description = "Name of the Cloud NAT"
  value       = module.network.nat_name
}

// MARK: - GKE Warm Standby

output "gke_cluster_name" {
  description = "Name of the GKE standby cluster"
  value       = module.gke.cluster_name
}

output "gke_cluster_location" {
  description = "Location of the GKE standby cluster"
  value       = module.gke.cluster_location
}

output "gke_cluster_dns_endpoint" {
  description = "DNS endpoint of the GKE standby cluster"
  value       = module.gke.cluster_dns_endpoint
}

output "gke_node_pool_name" {
  description = "Name of the warm standby node pool"
  value       = module.gke.node_pool_name
}

output "gke_node_service_account_email" {
  description = "Email of the GKE node service account"
  value       = module.gke.node_service_account_email
}