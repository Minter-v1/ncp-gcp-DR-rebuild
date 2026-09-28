// MARK: - VPC

resource "ncloud_vpc" "active" {
  name            = "${var.resource_prefix}-vpc"
  ipv4_cidr_block = var.vpc_cidr
}

// MARK: - Network ACL

resource "ncloud_network_acl" "alb" {
  name        = "${var.resource_prefix}-nacl-alb"
  description = "Network ACL for the public ALB subnet"
  vpc_no      = ncloud_vpc.active.id
}

resource "ncloud_network_acl" "web" {
  name        = "${var.resource_prefix}-nacl-web"
  description = "Network ACL for the private Web subnet"
  vpc_no      = ncloud_vpc.active.id
}

resource "ncloud_network_acl" "was" {
  name        = "${var.resource_prefix}-nacl-was"
  description = "Network ACL for the private WAS subnet"
  vpc_no      = ncloud_vpc.active.id
}

resource "ncloud_network_acl" "db" {
  name        = "${var.resource_prefix}-nacl-db"
  description = "Network ACL for the private DB subnet"
  vpc_no      = ncloud_vpc.active.id
}

// MARK: - Subnet

resource "ncloud_subnet" "alb" {
  name           = "${var.resource_prefix}-public-alb"
  vpc_no         = ncloud_vpc.active.id
  subnet         = var.alb_subnet_cidr
  zone           = var.ncloud_zone
  network_acl_no = ncloud_network_acl.alb.id
  subnet_type    = "PUBLIC"
  usage_type     = "LOADB"
}

resource "ncloud_subnet" "web" {
  name           = "${var.resource_prefix}-private-web"
  vpc_no         = ncloud_vpc.active.id
  subnet         = var.web_subnet_cidr
  zone           = var.ncloud_zone
  network_acl_no = ncloud_network_acl.web.id
  subnet_type    = "PRIVATE"
  usage_type     = "GEN"
}

resource "ncloud_subnet" "was" {
  name           = "${var.resource_prefix}-private-was"
  vpc_no         = ncloud_vpc.active.id
  subnet         = var.was_subnet_cidr
  zone           = var.ncloud_zone
  network_acl_no = ncloud_network_acl.was.id
  subnet_type    = "PRIVATE"
  usage_type     = "GEN"
}

resource "ncloud_subnet" "db" {
  name           = "${var.resource_prefix}-private-db"
  vpc_no         = ncloud_vpc.active.id
  subnet         = var.db_subnet_cidr
  zone           = var.ncloud_zone
  network_acl_no = ncloud_network_acl.db.id
  subnet_type    = "PRIVATE"
  usage_type     = "GEN"
}
