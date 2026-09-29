// MARK: - 프로젝트 기본 변수

variable "project_id" {
  description = "GCP project identifier"
  type        = string
}

variable "region" {
  description = "GCP region used by the warm standby environment"
  type        = string
  default     = "asia-northeast3"
}

variable "zone" {
  description = "Default GCP zone used by zonal resources"
  type        = string
  default     = "asia-northeast3-a"
}

variable "resource_prefix" {
  description = "Prefix applied to GCP resource names"
  type        = string
  default     = "dr-rebuild-lab"
}

// MARK: - 네트워크 변수

variable "gke_subnet_cidr" {
  description = "Primary CIDR assigned to GKE nodes"
  type        = string
  default     = "10.10.0.0/20"
}

variable "database_subnet_cidr" {
  description = "Primary CIDR assigned to the standby database"
  type        = string
  default     = "10.10.16.0/24"
}

variable "gke_pod_cidr" {
  description = "Secondary CIDR assigned to GKE pods"
  type        = string
  default     = "10.20.0.0/16"
}

variable "gke_service_cidr" {
  description = "Secondary CIDR assigned to Kubernetes services"
  type        = string
  default     = "10.30.0.0/20"
}

// MARK: - GKE 변수

variable "gke_node_locations" {
  description = "Zones used by the regional GKE node pool"
  type        = list(string)

  default = [
    "asia-northeast3-a",
    "asia-northeast3-b",
  ]
}

variable "gke_machine_type" {
  description = "Machine type used by the warm standby node pool"
  type        = string
  default     = "e2-standard-2"
}

variable "gke_min_node_count" {
  description = "Minimum node count per zone"
  type        = number
  default     = 1
}

variable "gke_max_node_count" {
  description = "Maximum node count per zone"
  type        = number
  default     = 3
}

variable "gke_master_cidr" {
  description = "Private CIDR assigned to the GKE control plane"
  type        = string
  default     = "172.16.0.0/28"
}