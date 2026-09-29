// MARK: - ACG 식별자

output "web_acg_no" {
  description = "Web Access Control Group identifier"
  value       = ncloud_access_control_group.web.id
}

output "was_acg_no" {
  description = "WAS Access Control Group identifier"
  value       = ncloud_access_control_group.was.id
}

output "bastion_acg_no" {
  description = "Bastion Access Control Group identifier"
  value       = ncloud_access_control_group.bastion.id
}