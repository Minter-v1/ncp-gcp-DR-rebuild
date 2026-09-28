// MARK: - NCP Provider 연결 설정

provider "ncloud" {
  region      = var.ncloud_region
  site        = var.ncloud_site
  support_vpc = true
}
