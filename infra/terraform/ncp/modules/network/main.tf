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

resource "ncloud_network_acl" "bastion" {
  name        = "${var.resource_prefix}-nacl-bastion"
  description = "Network ACL for the public Bastion subnet"
  vpc_no      = ncloud_vpc.active.id
}

resource "ncloud_network_acl" "nat_gateway" {
  name        = "${var.resource_prefix}-nacl-natgw"
  description = "Network ACL for the public NAT Gateway subnet"
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

resource "ncloud_subnet" "bastion" {
  name           = "${var.resource_prefix}-public-bastion"
  vpc_no         = ncloud_vpc.active.id
  subnet         = var.bastion_subnet_cidr
  zone           = var.ncloud_zone
  network_acl_no = ncloud_network_acl.bastion.id
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
}

resource "ncloud_subnet" "nat_gateway" {
  name           = "${var.resource_prefix}-public-natgw"
  vpc_no         = ncloud_vpc.active.id
  subnet         = var.nat_gateway_subnet_cidr
  zone           = var.ncloud_zone
  network_acl_no = ncloud_network_acl.nat_gateway.id
  subnet_type    = "PUBLIC"
  usage_type     = "NATGW"
}


// MARK: - NAT Gateway

resource "ncloud_nat_gateway" "active" {
  name        = "${var.resource_prefix}-natgw"
  description = "Public NAT Gateway for private Web and WAS subnets"

  vpc_no    = ncloud_vpc.active.id
  subnet_no = ncloud_subnet.nat_gateway.id
  zone      = var.ncloud_zone
}