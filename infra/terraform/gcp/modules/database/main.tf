// MARK: - Cloud SQL MySQL

resource "google_sql_database_instance" "standby" {
  project          = var.project_id
  name             = "${var.resource_prefix}-mysql"
  region           = var.region
  database_version = "MYSQL_8_4"

  // NOTE: - Terraform을 통한 실수 삭제 방지
  deletion_protection = true

  settings {
    tier              = var.database_tier
    edition           = "ENTERPRISE"
    availability_type = "ZONAL"

    disk_type       = "PD_SSD"
    disk_size       = 10
    disk_autoresize = true

    ip_configuration {
      ipv4_enabled       = false
      private_network    = var.network_id
      allocated_ip_range = var.private_service_range_name
    }

    backup_configuration {
      enabled                        = true
      binary_log_enabled             = true
      start_time                     = "18:00"
      location                       = var.region
      transaction_log_retention_days = 3

      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = false
    }
  }
}

// MARK: - Application Database

resource "google_sql_database" "greentech" {
  project   = var.project_id
  name      = var.database_name
  instance  = google_sql_database_instance.standby.name
  charset   = "utf8mb4"
  collation = "utf8mb4_unicode_ci"
}