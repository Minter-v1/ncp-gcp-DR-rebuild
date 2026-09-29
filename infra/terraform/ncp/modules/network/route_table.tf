// MARK: - Private Application Route Table

resource "ncloud_route_table" "private_app" {
  name                  = "${var.resource_prefix}-rt-private-app"
  description           = "Private route table for Web and WAS subnets"
  vpc_no                = ncloud_vpc.active.id
  supported_subnet_type = "PRIVATE"
}

// MARK: - Route Table Association

resource "ncloud_route_table_association" "web" {
  route_table_no = ncloud_route_table.private_app.id
  subnet_no      = ncloud_subnet.web.id
}

resource "ncloud_route_table_association" "was" {
  route_table_no = ncloud_route_table.private_app.id
  subnet_no      = ncloud_subnet.was.id
}

// MARK: - NAT Gateway Route

resource "ncloud_route" "private_app_internet" {
  route_table_no         = ncloud_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  target_type            = "NATGW"
  target_no              = ncloud_nat_gateway.active.id
  target_name            = ncloud_nat_gateway.active.name
}