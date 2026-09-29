// MARK: - VPC 식별자

output "network_id" {
  description = "Identifier of the GCP standby VPC"
  value       = google_compute_network.standby.id
}

output "network_name" {
  description = "Name of the GCP standby VPC"
  value       = google_compute_network.standby.name
}

// MARK: - Subnet 식별자

output "gke_subnetwork_id" {
  description = "Identifier of the GKE subnetwork"
  value       = google_compute_subnetwork.gke.id
}

output "gke_subnetwork_name" {
  description = "Name of the GKE subnetwork"
  value       = google_compute_subnetwork.gke.name
}

output "database_subnetwork_id" {
  description = "Identifier of the standby database subnetwork"
  value       = google_compute_subnetwork.database.id
}

// MARK: - GKE Secondary Range

output "gke_pod_range_name" {
  description = "Name of the GKE pod secondary range"
  value       = google_compute_subnetwork.gke.secondary_ip_range[0].range_name
}

output "gke_service_range_name" {
  description = "Name of the GKE service secondary range"
  value       = google_compute_subnetwork.gke.secondary_ip_range[1].range_name
}

// MARK: - Outbound Network

output "router_name" {
  description = "Name of the Cloud Router"
  value       = google_compute_router.standby.name
}

output "nat_name" {
  description = "Name of the Cloud NAT"
  value       = google_compute_router_nat.standby.name
}