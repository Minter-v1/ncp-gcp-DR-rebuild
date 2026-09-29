// MARK: - Security Module 변수

variable "resource_prefix" {
  description = "Prefix used in NCP security resource names"
  type        = string
}

variable "vpc_no" {
  description = "VPC identifier used by access control groups"
  type        = string
}

variable "alb_subnet_cidr" {
  description = "CIDR block assigned to the load balancer subnet"
  type        = string
}

variable "db_subnet_cidr" {
  description = "CIDR block assigned to the managed database subnet"
  type        = string
}

variable "admin_cidr" {
  description = "Administrator CIDR allowed to access the Bastion host"
  type        = string
}