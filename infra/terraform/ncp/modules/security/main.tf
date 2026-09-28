// MARK: - Access Control Group

resource "ncloud_access_control_group" "web" {
  name        = "${var.resource_prefix}-acg-web"
  description = "Access Control Group for the Web server"
  vpc_no      = var.vpc_no
}

resource "ncloud_access_control_group" "was" {
  name        = "${var.resource_prefix}-acg-was"
  description = "Access Control Group for the WAS server"
  vpc_no      = var.vpc_no
}



// MARK: - Web ACG 규칙

resource "ncloud_access_control_group_rule" "web" {
  access_control_group_no = ncloud_access_control_group.web.id

  inbound {
    protocol    = "TCP"
    ip_block    = var.alb_subnet_cidr
    port_range  = "3000"
    description = "Allow requests from ALB"
  }

  outbound {
    protocol                       = "TCP"
    source_access_control_group_no = ncloud_access_control_group.was.id
    port_range                     = "8080"
    description                    = "Allow requests to WAS"
  }
}

// MARK: - WAS ACG 규칙

resource "ncloud_access_control_group_rule" "was" {
  access_control_group_no = ncloud_access_control_group.was.id

  inbound {
    protocol                       = "TCP"
    source_access_control_group_no = ncloud_access_control_group.web.id
    port_range                     = "8080"
    description                    = "Allow requests from Web"
  }

  outbound {
    protocol    = "TCP"
    ip_block    = var.db_subnet_cidr
    port_range  = "3306"
    description = "Allow requests to managed MySQL"
  }
}
