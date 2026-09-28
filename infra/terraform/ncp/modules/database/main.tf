// MARK: - Cloud DB for MySQL

resource "ncloud_mysql" "active" {
  service_name       = "${var.resource_prefix}-mysql"
  server_name_prefix = "${var.resource_prefix}-db"
  subnet_no          = var.db_subnet_no

  image_product_code = data.ncloud_mysql_image_products.selected.image_product_list[0].product_code
  engine_version_code = var.mysql_engine_version_code
  data_storage_type   = "CB2"

  user_name     = var.mysql_user_name
  user_password = var.mysql_user_password
  host_ip       = var.mysql_user_host
  database_name = var.mysql_database_name

  is_ha                        = false # NOTE: - 현재 단일 존
  is_backup                    = false # NOTE: - 실험 환경에 백업 필요 없음
}

// MARK: - MySQL ACG 규칙

resource "ncloud_access_control_group_rule" "mysql" {
  access_control_group_no = ncloud_mysql.active.access_control_group_no_list[0]

  inbound {
    protocol                       = "TCP"
    source_access_control_group_no = var.was_acg_no
    port_range                     = "3306"
    description                    = "Allow MySQL access from WAS"
  }
}