// MARK: - Compute Module 변수

variable "resource_prefix" {
  description = "Prefix used in NCP compute resource names"
  type        = string
}

variable "web_subnet_no" {
  description = "Private Web subnet identifier"
  type        = string
}

variable "was_subnet_no" {
  description = "Private WAS subnet identifier"
  type        = string
}



variable "web_acg_no" {
  description = "Web Access Control Group identifier"
  type        = string
}

variable "was_acg_no" {
  description = "WAS Access Control Group identifier"
  type        = string
}


// MARK: - 서버 이미지 및 스펙 변수

variable "server_image_name" {
  description = "Base image name used by NCP servers"
  type        = string
}

variable "server_hypervisor_type" {
  description = "Hypervisor type used by NCP servers"
  type        = string
}

variable "server_spec_code" {
  description = "Specification code used by NCP servers"
  type        = string
}