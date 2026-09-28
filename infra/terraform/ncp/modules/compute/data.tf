// MARK: - 서버 이미지 조회

data "ncloud_server_image_numbers" "base" {
  server_image_name = var.server_image_name
  hypervisor_type   = var.server_hypervisor_type
}

// MARK: - 서버 스펙 조회

data "ncloud_server_specs" "default" {
  filter {
    name   = "server_spec_code"
    values = [var.server_spec_code]
  }
}