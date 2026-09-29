// MARK: - Network 모듈 입력 변수

variable "resource_prefix" {
  description = "Prefix applied to network resource names"
  type        = string
}

variable "region" {
  description = "GCP region used by network resources"
  type        = string
}

variable "gke_subnet_cidr" {
  description = "Primary CIDR assigned to GKE nodes"
  type        = string
}

variable "database_subnet_cidr" {
  description = "Primary CIDR assigned to the standby database"
  type        = string
}

variable "gke_pod_cidr" {
  description = "Secondary CIDR assigned to GKE pods"
  type        = string
}

variable "gke_service_cidr" {
  description = "Secondary CIDR assigned to Kubernetes services"
  type        = string
}