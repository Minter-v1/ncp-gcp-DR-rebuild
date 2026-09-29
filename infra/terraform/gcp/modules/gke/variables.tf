// MARK: - GKE 모듈 입력 변수

variable "project_id" {
  description = "GCP project identifier"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix applied to GKE resource names"
  type        = string
}

variable "region" {
  description = "Region used by the GKE cluster"
  type        = string
}

variable "network_id" {
  description = "VPC network identifier"
  type        = string
}

variable "gke_subnetwork_id" {
  description = "GKE subnetwork identifier"
  type        = string
}

variable "gke_pod_range_name" {
  description = "Secondary range name assigned to GKE pods"
  type        = string
}

variable "gke_service_range_name" {
  description = "Secondary range name assigned to Kubernetes services"
  type        = string
}

variable "node_locations" {
  description = "Zones used by the regional node pool"
  type        = list(string)
}

variable "machine_type" {
  description = "Machine type used by GKE nodes"
  type        = string
}

variable "min_node_count" {
  description = "Minimum node count per zone"
  type        = number
}

variable "max_node_count" {
  description = "Maximum node count per zone"
  type        = number
}

variable "master_ipv4_cidr_block" {
  description = "Private CIDR assigned to the GKE control plane"
  type        = string
}