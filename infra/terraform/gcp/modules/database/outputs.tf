// MARK: - Cloud SQL 출력값

output "instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.standby.name
}

output "connection_name" {
  description = "Cloud SQL connection name"
  value       = google_sql_database_instance.standby.connection_name
}

output "private_ip_address" {
  description = "Cloud SQL private IP address"
  value       = google_sql_database_instance.standby.private_ip_address
}

output "database_name" {
  description = "Application database name"
  value       = google_sql_database.greentech.name
}