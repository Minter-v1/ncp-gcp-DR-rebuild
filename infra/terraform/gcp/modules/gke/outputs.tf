// MARK: - GKE Cluster

output "cluster_name" {
  description = "Name of the GKE standby cluster"
  value       = google_container_cluster.standby.name
}

output "cluster_location" {
  description = "Location of the GKE standby cluster"
  value       = google_container_cluster.standby.location
}

output "cluster_dns_endpoint" {
  description = "DNS endpoint of the GKE standby cluster"
  value       = google_container_cluster.standby.control_plane_endpoints_config[0].dns_endpoint_config[0].endpoint
}

output "node_pool_name" {
  description = "Name of the warm standby node pool"
  value       = google_container_node_pool.standby.name
}

output "node_service_account_email" {
  description = "Email of the GKE node service account"
  value       = google_service_account.gke_nodes.email
}

// MARK: - WAS Runtime Identity

output "was_service_account_email" {
  description = "Google Service Account email used by the WAS workload"
  value       = google_service_account.was_runtime.email
}