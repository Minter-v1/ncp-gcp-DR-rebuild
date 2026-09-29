// MARK: - ALB NACL 규칙

resource "ncloud_network_acl_rule" "alb" {
  network_acl_no = ncloud_network_acl.alb.id

  inbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    rule_action = "ALLOW"
    description = "ALLOW public HTTP traffic"
  }

  inbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    rule_action = "ALLOW"
    description = "ALLOW public HTTPS traffic"
  }

  inbound {
    priority    = 120
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW response traffic from Web"
  }

  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "3000"
    rule_action = "ALLOW"
    description = "ALLOW requests and health checks to Web"
  }

  outbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1-65535"
    rule_action = "ALLOW"
    description = "ALLOW response traffic to external clients"
  }
}

// MARK: - Web NACL 규칙

resource "ncloud_network_acl_rule" "web" {
  network_acl_no = ncloud_network_acl.web.id

  // from alb
  inbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.alb_subnet_cidr
    port_range  = "3000"
    rule_action = "ALLOW"
    description = "ALLOW requests from ALB"
  }

  // from was
  inbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW response traffic from WAS"
  }

  // from bastion
  inbound {
    priority    = 120
    protocol    = "TCP"
    ip_block    = var.bastion_subnet_cidr
    port_range  = "22"
    rule_action = "ALLOW"
    description = "ALLOW SSH from Bastion"
  }

  // from NAT Gateway
  inbound {
    priority    = 130
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW TCP responses through NAT Gateway"
  }

  inbound {
    priority    = 140
    protocol    = "UDP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW TCP responses through NAT Gateway"
  }

  // to alb
  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.alb_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW response traffic to ALB"
  }

  // to was
  outbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "41783"
    rule_action = "ALLOW"
    description = "ALLOW requests to WAS"
  }

  // to bastion
  outbound {
    priority    = 120
    protocol    = "TCP"
    ip_block    = var.bastion_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW response traffic to Bastion"
  }

  // to NAT Gateway
  outbound {
    priority    = 130
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    rule_action = "ALLOW"
    description = "ALLOW HTTP requests through NAT Gateway"
  }

  outbound {
    priority    = 140
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    rule_action = "ALLOW"
    description = "ALLOW HTTP requests through NAT Gateway"
  }

}

// MARK: - WAS NACL 규칙

resource "ncloud_network_acl_rule" "was" {
  network_acl_no = ncloud_network_acl.was.id

  inbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "41783"
    rule_action = "ALLOW"
    description = "ALLOW requests from Web"
  }

  inbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.db_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW response traffic from DB"
  }

  // from bastion
  inbound {
    priority    = 120
    protocol    = "TCP"
    ip_block    = var.bastion_subnet_cidr
    port_range  = "22"
    rule_action = "ALLOW"
    description = "ALLOW SSH from Bastion"
  }

  // from NAT Gateway
  inbound {
    priority    = 130
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW TCP responses through NAT Gateway"
  }

  inbound {
    priority    = 140
    protocol    = "UDP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW TCP responses through NAT Gateway"
  }



  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW response traffic to Web"
  }

  outbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.db_subnet_cidr
    port_range  = "3306"
    rule_action = "ALLOW"
    description = "ALLOW requests to DB"
  }

  // to bastion
  outbound {
    priority    = 120
    protocol    = "TCP"
    ip_block    = var.bastion_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW response traffic to Bastion"
  }

  // to NAT Gateway
  outbound {
    priority    = 130
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    rule_action = "ALLOW"
    description = "ALLOW HTTP requests through NAT Gateway"
  }

  outbound {
    priority    = 140
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    rule_action = "ALLOW"
    description = "ALLOW HTTP requests through NAT Gateway"
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
    description = "ALLOW requests from WAS"
  }

  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW response traffic to WAS"
  }
}


// MARK: - Bastion NACL 
resource "ncloud_network_acl_rule" "bastion" {
  network_acl_no = ncloud_network_acl.bastion.id

  inbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.admin_cidr
    port_range  = "22"
    rule_action = "ALLOW"
    description = "ALLOW SSH from administrator"
  }

  inbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW SSH response from web"
  }

  inbound {
    priority    = 130
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW SSH response from was"
  }

  // 패키지 다운로드 용
  inbound {
    priority    = 140
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow TCP responses from internet"
  }

  inbound {
    priority    = 150
    protocol    = "UDP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow TCP responses from internet"
  }

  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = var.admin_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "ALLOW SSH response to administrator"
  }

  outbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "22"
    rule_action = "ALLOW"
    description = "ALLOW SSH to web"
  }

  outbound {
    priority    = 120
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "22"
    rule_action = "ALLOW"
    description = "ALLOW SSH to was"
  }

  // 패키지 다운로드용
  outbound {
    priority    = 130
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    rule_action = "ALLOW"
    description = "Allow HTTP package downloads"
  }

  outbound {
    priority    = 140
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    rule_action = "ALLOW"
    description = "Allow HTTPS package downloads"
  }
}

// MARK: - NAT Gateway NACL
resource "ncloud_network_acl_rule" "nat_gateway" {
  network_acl_no = ncloud_network_acl.nat_gateway.id

  // from internet
  inbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow TCP response traffic from internet"
  }

  // from web
  inbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "80"
    rule_action = "ALLOW"
    description = "Allow HTTP requests from web"
  }

  inbound {
    priority    = 120
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "443"
    rule_action = "ALLOW"
    description = "Allow HTTPS requests from web"
  }

  // from was
  inbound {
    priority    = 130
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "80"
    rule_action = "ALLOW"
    description = "Allow HTTP requests from WAS"
  }

  inbound {
    priority    = 140
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "443"
    rule_action = "ALLOW"
    description = "Allow HTTPS requests from WAS"
  }


  // to internet
  outbound {
    priority    = 100
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    rule_action = "ALLOW"
    description = "Allow HTTP requests to internet"
  }

  outbound {
    priority    = 110
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "443"
    rule_action = "ALLOW"
    description = "Allow HTTPS requests to internet"
  }

  // to web
  outbound {
    priority    = 120
    protocol    = "TCP"
    ip_block    = var.web_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow TCP responses to web"
  }

  // to was
  outbound {
    priority    = 130
    protocol    = "TCP"
    ip_block    = var.was_subnet_cidr
    port_range  = "1024-65535"
    rule_action = "ALLOW"
    description = "Allow TCP responses to WAS"
  }

}
