// MARK: - ALB NACL 규칙

resource "ncloud_network_acl_rule" "alb" {
  network_acl_no = ncloud_network_acl.alb.id

  inbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    rule_action = "ALLOW"
    description = "Allow public HTTP traffic"
  }

  inbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    rule_action = "ALLOW"
    description = "Allow public HTTPS traffic"
  }

  inbound {
    priority    = 120
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow response traffic from Web"
  }

  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "3000"
    rule_action = "ALLOW"
    description = "Allow requests and health checks to Web"
  }

  outbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1-65535"
    rule_action = "ALLOW"
    description = "Allow response traffic to external clients"
  }
}

// MARK: - Web NACL 규칙

resource "ncloud_network_acl_rule" "web" {
  network_acl_no = ncloud_network_acl.web.id

  inbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.alb_subnet_cidr
    port_range  = "3000"
    rule_action = "ALLOW"
    description = "Allow requests from ALB"
  }

  inbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow response traffic from WAS"
  }

  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.alb_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow response traffic to ALB"
  }

  outbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "8080"
    rule_action = "ALLOW"
    description = "Allow requests to WAS"
  }
}

// MARK: - WAS NACL 규칙

resource "ncloud_network_acl_rule" "was" {
  network_acl_no = ncloud_network_acl.was.id

  inbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "8080"
    rule_action = "ALLOW"
    description = "Allow requests from Web"
  }

  inbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.db_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow response traffic from DB"
  }

  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow response traffic to Web"
  }

  outbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.db_subnet_cidr
    port_range  = "3306"
    rule_action = "ALLOW"
    description = "Allow requests to DB"
  }
}

// MARK: - DB NACL 규칙

resource "ncloud_network_acl_rule" "db" {
  network_acl_no = ncloud_network_acl.db.id

  inbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "3306"
    rule_action = "ALLOW"
    description = "Allow requests from WAS"
  }

  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow response traffic to WAS"
  }
}
