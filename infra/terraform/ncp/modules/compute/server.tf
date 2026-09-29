// MARK: - Web Server

resource "ncloud_server" "web" {
  name        = "${var.resource_prefix}-web"
  description = "Web server for the NCP active environment"

  subnet_no           = var.web_subnet_no
  server_image_number = data.ncloud_server_image_numbers.base.image_number_list[0].server_image_number
  server_spec_code    = data.ncloud_server_specs.default.server_spec_list[0].server_spec_code
  login_key_name      = ncloud_login_key.server.key_name

  fee_system_type_code          = "MTRAT"
  is_protect_server_termination = false

  network_interface {
    network_interface_no = ncloud_network_interface.web.id
    order                = 0
  }
}

// MARK: - WAS Server

resource "ncloud_server" "was" {
  name        = "${var.resource_prefix}-was"
  description = "WAS server for the NCP active environment"

  subnet_no           = var.was_subnet_no
  server_image_number = data.ncloud_server_image_numbers.base.image_number_list[0].server_image_number
  server_spec_code    = data.ncloud_server_specs.default.server_spec_list[0].server_spec_code
  login_key_name      = ncloud_login_key.server.key_name

  fee_system_type_code          = "MTRAT"
  is_protect_server_termination = false

  network_interface {
    network_interface_no = ncloud_network_interface.was.id
    order                = 0
  }
}

// MARK: - Bastion Server

resource "ncloud_server" "bastion" {
  name        = "${var.resource_prefix}-bastion"
  description = "Bastion server for administrative access"

  subnet_no           = var.bastion_subnet_no
  server_image_number = data.ncloud_server_image_numbers.base.image_number_list[0].server_image_number
  server_spec_code    = data.ncloud_server_specs.default.server_spec_list[0].server_spec_code
  login_key_name      = ncloud_login_key.server.key_name

  fee_system_type_code          = "MTRAT"
  is_protect_server_termination = false

  network_interface {
    network_interface_no = ncloud_network_interface.bastion.id
    order                = 0
  }
}