// MARK: - 네트워크 식별자

output "vpc_no" {
  description = "NCP Active VPC identifier"
  value       = module.network.vpc_no
}

output "alb_subnet_no" {
  description = "ALB subnet identifier"
  value       = module.network.alb_subnet_no
}

output "private_web_subnet_no" {
  description = "Private web subnet identifier"
  value       = module.network.web_subnet_no
}

output "private_was_subnet_no" {
  description = "Private was subnet identifier"
  value       = module.network.was_subnet_no
}

output "private_db_subnet_no" {
  description = "Private db subnet identifier"
  value       = module.network.db_subnet_no
}


// MARK: - Web/WAS 서버 이미지 및 스펙

output "server_image_number" {
  description = "Selected NCP server image number for Web and WAS"
  value       = module.compute.server_image_number
}

output "server_spec_code" {
  description = "Selected NCP server specification code for Web and WAS"
  value       = module.compute.server_spec_code
}

// MARK: - Cloud DB for MySQL 변수

variable "mysql_engine_version_code" {
  description = "Cloud DB for MySQL engine version"
  type        = string
  default     = "8.4.11"
}

variable "mysql_generation_code" {
  description = "Cloud DB for MySQL server generation"
  type        = string
  default     = "G3"
}

variable "mysql_user_name" {
  description = "Cloud DB for MySQL administrator username"
  type        = string
  default     = "dradmin"
}

variable "mysql_user_password" {
  description = "Cloud DB for MySQL administrator password"
  type        = string
  sensitive   = true
}

variable "mysql_user_host" {
  description = "Network range allowed for the initial MySQL user"
  type        = string
  default     = "10.0.3.%"
}

variable "mysql_database_name" {
  description = "Initial Cloud DB for MySQL database name"
  type        = string
  default     = "greentech"
}

// MARK: - Cloud DB for MySQL

output "mysql_instance_no" {
  description = "Cloud DB for MySQL instance identifier"
  value       = module.database.instance_no
}

output "mysql_private_domain" {
  description = "Private domain used by the WAS server"
  value       = module.database.private_domain
}

output "mysql_port" {
  description = "Cloud DB for MySQL connection port"
  value       = module.database.port
}

// MARK: - 서버 로그인 키

output "server_login_key_name" {
  description = "Login key name used by Web and WAS servers"
  value       = module.compute.login_key_name
}

output "server_login_key_fingerprint" {
  description = "Fingerprint of the NCP server login key"
  value       = module.compute.login_key_fingerprint
}

output "server_login_private_key" {
  description = "Private key used to retrieve initial server passwords"
  value       = module.compute.login_private_key
  sensitive   = true
}

// MARK: - Web/WAS Server

output "web_server_instance_no" {
  description = "Web server instance identifier"
  value       = module.compute.web_server_instance_no
}

output "was_server_instance_no" {
  description = "WAS server instance identifier"
  value       = module.compute.was_server_instance_no
}

output "web_server_private_ip" {
  description = "Private IP address of the Web server"
  value       = module.compute.web_server_private_ip
}

output "was_server_private_ip" {
  description = "Private IP address of the WAS server"
  value       = module.compute.was_server_private_ip
}