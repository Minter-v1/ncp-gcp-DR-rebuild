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

// MARK: - Bastion Network Interface

resource "ncloud_network_interface" "bastion" {
  name                  = "${var.resource_prefix}-nic-bastion"
  description           = "Network interface for the Bastion server"
  subnet_no             = var.bastion_subnet_no
  access_control_groups = [var.bastion_acg_no] // NOTE: - Bastion ACG 적용
}