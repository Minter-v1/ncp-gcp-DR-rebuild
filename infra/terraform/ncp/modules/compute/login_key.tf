// MARK: - 서버 로그인 키

resource "ncloud_login_key" "server" {
  key_name = "${var.resource_prefix}-login-key"
}