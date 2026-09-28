// MARK: - MySQL 이미지 조회

data "ncloud_mysql_image_products" "selected" {
  filter {
    name   = "engine_version_code"
    values = [var.mysql_engine_version_code]
  }

  filter {
    name   = "generation_code"
    values = [var.mysql_generation_code]
  }
}