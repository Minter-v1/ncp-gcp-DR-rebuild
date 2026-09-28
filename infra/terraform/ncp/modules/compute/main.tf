// MARK: - Web Network Interface

resource "ncloud_network_interface" "web" {
  name                  = "${var.resource_prefix}-nic-web"
  description           = "Network interface for the Web server"
  subnet_no             = var.web_subnet_no
  access_control_groups = [var.web_acg_no] // NOTE: - ACG 적용해줌
}

// MARK: - WAS Network Interface

resource "ncloud_network_interface" "was" {
  name                  = "${var.resource_prefix}-nic-was"
  description           = "Network interface for the WAS server"
  subnet_no             = var.was_subnet_no
  access_control_groups = [var.was_acg_no] // NOTE: - ACG 적용해줌
}
