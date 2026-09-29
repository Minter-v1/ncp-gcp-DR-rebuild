// MARK: - 공통 변수

variable "resource_prefix" {
  description = "Prefix used in NCP network resource names"
  type        = string
}

variable "ncloud_zone" {
  description = "NCP zone code"
  type        = string
}

// MARK: - 네트워크 변수

variable "vpc_cidr" {
  description = "CIDR block assigned to the NCP VPC"
  type        = string
}

variable "alb_subnet_cidr" {
  description = "CIDR block assigned to the load balancer subnet"
  type        = string
}

variable "web_subnet_cidr" {
  description = "CIDR block assigned to the private web subnet"
  type        = string
}

variable "was_subnet_cidr" {
  description = "CIDR block assigned to the private WAS subnet"
  type        = string
}

variable "db_subnet_cidr" {
  description = "CIDR block assigned to the private DB subnet"
  type        = string
}

variable "bastion_subnet_cidr" {
  description = "CIDR block assigned to the public Bastion subnet"
  type        = string
}

variable "nat_gateway_subnet_cidr" {
  description = "CIDR block assigned to the public NAT Gateway subnet"
  type        = string
}

variable "admin_cidr" {
  description = "Administrator public IP CIDR allowed to access the Bastion host"
  type        = string
}