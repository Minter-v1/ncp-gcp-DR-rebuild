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

// MARK: - Private Service Access

output "private_service_range_name" {
  description = "Name of the allocated private service access range"
  value       = google_compute_global_address.private_service_access.name
}

output "private_service_connection_id" {
  description = "Identifier of the private service networking connection"
  value       = google_service_networking_connection.private_service_access.id
}


// MARK: - Global Load Balancer Public IP

output "web_global_ip_name" {
  description = "Name of the global static IP reserved for the Web load balancer"
  value       = google_compute_global_address.web.name
}

output "web_global_ip_address" {
  description = "Global static IP reserved for the Web load balancer"
  value       = google_compute_global_address.web.address
}