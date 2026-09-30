// MARK: - Database 모듈 입력 변수

variable "project_id" {
  description = "GCP project identifier"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix applied to Cloud SQL resources"
  type        = string
}

variable "region" {
  description = "Region used by the Cloud SQL instance"
  type        = string
}

variable "network_id" {
  description = "VPC network identifier used by Cloud SQL"
  type        = string
}

variable "private_service_range_name" {
  description = "Allocated private service access range name"
  type        = string
}

variable "database_name" {
  description = "Application database name"
  type        = string
  default     = "greentech"
}

variable "database_tier" {
  description = "Cloud SQL machine tier"
  type        = string
  default     = "db-g1-small"
}