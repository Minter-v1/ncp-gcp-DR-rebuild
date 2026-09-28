// MARK: - Cloud DB 식별자

output "instance_no" {
  description = "Cloud DB for MySQL instance identifier"
  value       = ncloud_mysql.active.id
}

output "private_domain" {
  description = "Private domain of the Cloud DB for MySQL server"
  value       = ncloud_mysql.active.mysql_server_list[0].private_domain
}

output "access_control_group_no" {
  description = "Automatically created Cloud DB ACG identifier"
  value       = ncloud_mysql.active.access_control_group_no_list[0]
}

output "port" {
  description = "Cloud DB for MySQL connection port"
  value       = ncloud_mysql.active.port
}