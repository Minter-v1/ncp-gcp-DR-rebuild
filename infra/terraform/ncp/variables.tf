// MARK: - 프로젝트 공통 변수
variable "project_name" {
  description = "Project name used in NCP resource names"
  type        = string
  default     = "dr-rebuild" // NOTE: - 리소스 이름 prefix
}

variable "environment" {
  description = "Inrfastructure environment"
  type        = string
  default     = "lab" // NOTE: - 환경 구분(실험)
}

// MARK: - NCP Provider 변수

variable "ncloud_region" {
  description = "NCP region code"
  type        = string
  default     = "KR"
}

variable "ncloud_site" {
  description = "NCP service site"
  type        = string
  default     = "public"
}

variable "ncloud_zone" {
  description = "NCP zone code"
  type        = string
  default     = "KR-1" // NOTE: - 단일 존 고정
}

// MARK: - 네트워크 변수
variable "vpc_cidr" {
  description = "CIDR block assigned to the NCP VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "alb_subnet_cidr" {
  description = "CIDR block assigned to the load balancer subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "web_subnet_cidr" {
  description = "CIDR block assigned to the private web subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "was_subnet_cidr" {
  description = "CIDR block assigned to the private was subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR block assigned to the private db subnet"
  type        = string
  default     = "10.0.4.0/24"
}

// MARK: - 서버 이미지 및 스펙 변수
variable "server_image_name" {
  description = "Base image name used by NCP servers"
  type        = string
  default     = "rocky-8.10-base"
}

variable "server_hypervisor_type" {
  description = "Hypervisor type used by NCP servers"
  type        = string
  default     = "KVM"
}

variable "server_spec_code" {
  description = "Specification code used by NCP servers"
  type        = string
  default     = "c2-g3" // NOTE: - 실습 환경 Compact 사양
}