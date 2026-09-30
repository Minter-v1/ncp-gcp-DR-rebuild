// MARK: - Custom VPC

resource "google_compute_network" "standby" {
  name                    = "${var.resource_prefix}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

// MARK: - GKE Subnet

resource "google_compute_subnetwork" "gke" {
  name          = "${var.resource_prefix}-gke-subnet"
  region        = var.region
  network       = google_compute_network.standby.id
  ip_cidr_range = var.gke_subnet_cidr

  private_ip_google_access = true

  // NOTE: - GKE Pod와 Service는 Node 대역과 분리된 Secondary Range를 사용

  secondary_ip_range {
    range_name    = "${var.resource_prefix}-pod-range"
    ip_cidr_range = var.gke_pod_cidr
  }

  secondary_ip_range {
    range_name    = "${var.resource_prefix}-service-range"
    ip_cidr_range = var.gke_service_cidr
  }
}

// MARK: - Standby Database Subnet

resource "google_compute_subnetwork" "database" {
  name          = "${var.resource_prefix}-db-subnet"
  region        = var.region
  network       = google_compute_network.standby.id
  ip_cidr_range = var.database_subnet_cidr

  private_ip_google_access = true # NOTE: - 외부 IP가 없는 리소스가 Google API에 접근할 수 있게 함
}

// MARK: - Cloud Router

resource "google_compute_router" "standby" {
  name    = "${var.resource_prefix}-router"
  region  = var.region
  network = google_compute_network.standby.id
}

// MARK: - Cloud NAT

resource "google_compute_router_nat" "standby" {
  name   = "${var.resource_prefix}-nat"
  region = var.region
  router = google_compute_router.standby.name

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.gke.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.database.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

// MARK: - Private Service Access

resource "google_compute_global_address" "private_service_access" {
  name          = "${var.resource_prefix}-private-service-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24 # NOTE: - GCP가 현재 VPC와 충돌하지 않는 내부 대역을 할당
  network       = google_compute_network.standby.id
}

// NOTE: - Cloud SQL Private IP는 일반 Subnet이 아닌 Service Networking Peering 대역을 사용

resource "google_service_networking_connection" "private_service_access" {
  network                 = google_compute_network.standby.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access.name]
}


// MARK: - Global Load Balancer Public IP

resource "google_compute_global_address" "web" {
  name         = "${var.resource_prefix}-web-ip"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}