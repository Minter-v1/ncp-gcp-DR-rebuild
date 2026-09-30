// MARK: - GKE Node Service Account

resource "google_service_account" "gke_nodes" {
  account_id   = "${var.resource_prefix}-gke-nodes"
  display_name = "GKE Warm Standby Node Service Account"
}

resource "google_project_iam_member" "gke_default_node" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

// MARK: - GKE Regional Cluster

resource "google_container_cluster" "standby" {
  name     = "${var.resource_prefix}-gke"
  location = var.region

  network    = var.network_id
  subnetwork = var.gke_subnetwork_id

  node_locations = var.node_locations

  networking_mode          = "VPC_NATIVE"
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.gke_pod_range_name
    services_secondary_range_name = var.gke_service_range_name
  }

  // MARK: - Private Node

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }

  // MARK: - DNS 기반 Control Plane 접근

  control_plane_endpoints_config {
    dns_endpoint_config {
      allow_external_traffic    = true
      enable_k8s_tokens_via_dns = false
      enable_k8s_certs_via_dns  = false
    }

    ip_endpoints_config {
      enabled = false
    }
  }

  // MARK: - Workload Identity

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  // MARK: - Secret Manager Add-on

  secret_manager_config {
    enabled = true
  }

  enable_shielded_nodes = true

  // NOTE: - Cluster 생성에 필요한 임시 기본 Node Pool도 전용 계정을 사용

  node_config {
    service_account = google_service_account.gke_nodes.email
  }

  lifecycle {
    ignore_changes = [node_config]
  }

  depends_on = [
    google_project_iam_member.gke_default_node,
    google_project_iam_member.artifact_registry_reader,
  ]
}

// MARK: - Warm Standby Node Pool

resource "google_container_node_pool" "standby" {
  name     = "${var.resource_prefix}-standby-pool"
  location = var.region
  cluster  = google_container_cluster.standby.name

  node_locations = var.node_locations

  initial_node_count = var.min_node_count
  max_pods_per_node  = 64

  autoscaling {
    min_node_count  = var.min_node_count
    max_node_count  = var.max_node_count
    location_policy = "BALANCED"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  node_config {
    machine_type = var.machine_type
    image_type   = "COS_CONTAINERD"
    disk_type    = "pd-balanced"
    disk_size_gb = 50

    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      environment = "standby"
      workload    = "greentech"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }
}

// MARK: - WAS Runtime Service Account

resource "google_service_account" "was_runtime" {
  project      = var.project_id
  account_id   = "${var.resource_prefix}-was"
  display_name = "Greentech WAS Runtime Service Account"
}

// MARK: - Cloud SQL Client 권한

resource "google_project_iam_member" "was_cloud_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.was_runtime.email}"
}

// MARK: - Secret Manager 최소 권한

resource "google_secret_manager_secret_iam_member" "was_secret_accessor" {
  for_each = var.was_secret_ids

  project   = var.project_id
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.was_runtime.email}"
}

// MARK: - Workload Identity 연결

resource "google_service_account_iam_member" "was_workload_identity" {
  service_account_id = google_service_account.was_runtime.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.was_namespace}/${var.was_service_account_name}]"
}