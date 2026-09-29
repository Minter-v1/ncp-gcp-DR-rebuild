// MARK: - 네트워크 식별자

output "vpc_no" {
  description = "NCP Active VPC identifier"
  value       = ncloud_vpc.active.id
}

output "alb_subnet_no" {
  description = "ALB subnet identifier"
  value       = ncloud_subnet.alb.id
}

output "web_subnet_no" {
  description = "Private Web subnet identifier"
  value       = ncloud_subnet.web.id
}

output "was_subnet_no" {
  description = "Private WAS subnet identifier"
  value       = ncloud_subnet.was.id
}

output "db_subnet_no" {
  description = "Private DB subnet identifier"
  value       = ncloud_subnet.db.id
}

// MARK: - 관리 및 아웃바운드 Subnet 식별자

output "bastion_subnet_no" {
  description = "Public Bastion subnet identifier"
  value       = ncloud_subnet.bastion.id
}

output "nat_gateway_subnet_no" {
  description = "Public NAT Gateway subnet identifier"
  value       = ncloud_subnet.nat_gateway.id
}