// MARK: - Database Module 변수

variable "resource_prefix" {
  description = "Prefix used in NCP database resource names"
  type        = string
}

variable "db_subnet_no" {
  description = "Private database subnet identifier"
  type        = string
}

variable "was_acg_no" {
  description = "WAS Access Control Group identifier"
  type        = string
}

// MARK: - MySQL 설정 변수

variable "mysql_engine_version_code" {
  description = "Cloud DB for MySQL engine version"
  type        = string
}

variable "mysql_generation_code" {
  description = "Cloud DB for MySQL server generation"
  type        = string
}

variable "mysql_user_name" {
  description = "Cloud DB for MySQL administrator username"
  type        = string
}

variable "mysql_user_password" {
  description = "Cloud DB for MySQL administrator password"
  type        = string
  sensitive   = true
}

variable "mysql_user_host" {
  description = "Network range allowed for the initial MySQL user"
  type        = string
}

variable "mysql_database_name" {
  description = "Initial Cloud DB for MySQL database name"
  type        = string
}