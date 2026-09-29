// MARK: - Network Interface 식별자

output "web_network_interface_no" {
  description = "Web network interface identifier"
  value       = ncloud_network_interface.web.id
}

output "was_network_interface_no" {
  description = "WAS network interface identifier"
  value       = ncloud_network_interface.was.id
}

// MARK: - 서버 이미지 및 스펙

output "server_image_number" {
  description = "Selected NCP server image number"
  value       = data.ncloud_server_image_numbers.base.image_number_list[0].server_image_number
}

output "server_spec_code" {
  description = "Selected NCP server specification code"
  value       = data.ncloud_server_specs.default.server_spec_list[0].server_spec_code
}

// MARK: - 서버 로그인 키

output "login_key_name" {
  description = "Login key name used by Web and WAS servers"
  value       = ncloud_login_key.server.key_name
}

output "login_key_fingerprint" {
  description = "Fingerprint of the NCP server login key"
  value       = ncloud_login_key.server.fingerprint
}

output "login_private_key" {
  description = "Private key used to retrieve initial server passwords"
  value       = ncloud_login_key.server.private_key
  sensitive   = true
}

// MARK: - Web/WAS Server 식별자

output "web_server_instance_no" {
  description = "Web server instance identifier"
  value       = ncloud_server.web.id
}

output "was_server_instance_no" {
  description = "WAS server instance identifier"
  value       = ncloud_server.was.id
}

output "web_server_private_ip" {
  description = "Private IP address of the Web server"
  value       = ncloud_server.web.private_ip
}

output "was_server_private_ip" {
  description = "Private IP address of the WAS server"
  value       = ncloud_server.was.private_ip
}

// MARK: - Bastion Server 식별자

output "bastion_network_interface_no" {
  description = "Bastion network interface identifier"
  value       = ncloud_network_interface.bastion.id
}

output "bastion_server_instance_no" {
  description = "Bastion server instance identifier"
  value       = ncloud_server.bastion.id
}

output "bastion_private_ip" {
  description = "Private IP address of the Bastion server"
  value       = ncloud_server.bastion.private_ip
}

output "bastion_public_ip" {
  description = "Public IP address of the Bastion server"
  value       = ncloud_public_ip.bastion.public_ip
}