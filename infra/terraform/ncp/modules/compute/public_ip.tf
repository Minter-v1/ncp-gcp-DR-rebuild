// MARK: - Bastion Public IP

resource "ncloud_public_ip" "bastion" {
  server_instance_no = ncloud_server.bastion.id
  description        = "Public IP for the Bastion server"
}