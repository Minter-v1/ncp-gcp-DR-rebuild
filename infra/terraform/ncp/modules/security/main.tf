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

resource "ncloud_access_control_group" "bastion" {
  name        = "${var.resource_prefix}-acg-bastion"
  description = "Access Control Group for the Bastion server"
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

  // from bastion
  inbound {
    protocol                       = "TCP"
    source_access_control_group_no = ncloud_access_control_group.bastion.id
    port_range                     = "22"
    description                    = "Allow SSH from Bastion"
  }

  outbound {
    protocol                       = "TCP"
    source_access_control_group_no = ncloud_access_control_group.was.id
    port_range                     = "41783"
    description                    = "Allow requests to WAS"
  }

  // 패키지 다운로드용
  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    description = "Allow HTTP package downloads"
  }

  // Container Registry 접근 허용(or 패키지 다운로드)
  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    description = "Allow HTTPS package downloads or Allow HTTPS registry access"
  }
}

// MARK: - WAS ACG 규칙

resource "ncloud_access_control_group_rule" "was" {
  access_control_group_no = ncloud_access_control_group.was.id

  inbound {
    protocol                       = "TCP"
    source_access_control_group_no = ncloud_access_control_group.web.id
    port_range                     = "41783"
    description                    = "Allow requests from Web"
  }

  // from bastion
  inbound {
    protocol                       = "TCP"
    source_access_control_group_no = ncloud_access_control_group.bastion.id
    port_range                     = "22"
    description                    = "Allow SSH from Bastion"
  }

  outbound {
    protocol    = "TCP"
    ip_block    = var.db_subnet_cidr
    port_range  = "3306"
    description = "Allow requests to managed MySQL"
  }

  // 패키지 다운로드용
  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    description = "Allow HTTP package downloads"
  }

  // Container Registry 접근 허용(or 패키지 다운로드)
  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    description = "Allow HTTPS package downloads or Allow HTTPS registry access"
  }
}


// MARK: - Bastion ACG 규칙

resource "ncloud_access_control_group_rule" "bastion" {
  access_control_group_no = ncloud_access_control_group.bastion.id

  // NOTE: - 관리자 SSH 접근 허용
  inbound {
    protocol    = "TCP"
    ip_block    = var.admin_cidr
    port_range  = "22"
    description = "Allow SSH access from administrator"
  }

  // NOTE: - WEB 서버 SSH 접근 허용
  outbound {
    protocol                       = "TCP"
    source_access_control_group_no = ncloud_access_control_group.web.id
    port_range                     = "22"
    description                    = "Allow SSH access to Web"
  }

  // NOTE: - WAS 서버 SSH 접근 허용
  outbound {
    protocol                       = "TCP"
    source_access_control_group_no = ncloud_access_control_group.was.id
    port_range                     = "22"
    description                    = "Allow SSH access to WAS"
  }
}

