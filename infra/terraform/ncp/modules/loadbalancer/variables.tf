// MARK: - Load Balancer 모듈 변수

variable "resource_prefix" {
  description = "Prefix used in NCP load balancer resource names"
  type        = string
}

variable "vpc_no" {
  description = "VPC identifier used by the target group"
  type        = string
}

variable "alb_subnet_no" {
  description = "Public LOADB subnet identifier"
  type        = string
}

variable "web_server_instance_no" {
  description = "Web server instance identifier attached to the target group"
  type        = string
}