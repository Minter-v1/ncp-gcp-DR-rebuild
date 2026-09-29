// MARK: - Network Module

module "network" {
  source = "./modules/network" # NOTE: - 모듈 연결

  resource_prefix         = local.resource_prefix
  ncloud_zone             = var.ncloud_zone
  vpc_cidr                = var.vpc_cidr
  alb_subnet_cidr         = var.alb_subnet_cidr
  web_subnet_cidr         = var.web_subnet_cidr
  was_subnet_cidr         = var.was_subnet_cidr
  db_subnet_cidr          = var.db_subnet_cidr
  bastion_subnet_cidr     = var.bastion_subnet_cidr
  nat_gateway_subnet_cidr = var.nat_gateway_subnet_cidr
  admin_cidr              = var.admin_cidr
}

// MARK: - Security Module

module "security" {
  source = "./modules/security" # NOTE: - 모듈 연결

  resource_prefix = local.resource_prefix
  vpc_no          = module.network.vpc_no
  alb_subnet_cidr = var.alb_subnet_cidr
  db_subnet_cidr  = var.db_subnet_cidr
  admin_cidr      = var.admin_cidr
}

// MARK: - Compute Module

module "compute" {
  source = "./modules/compute" # NOTE: - 모듈 연결

  resource_prefix        = local.resource_prefix
  web_subnet_no          = module.network.web_subnet_no
  was_subnet_no          = module.network.was_subnet_no
  bastion_subnet_no      = module.network.bastion_subnet_no
  web_acg_no             = module.security.web_acg_no
  was_acg_no             = module.security.was_acg_no
  bastion_acg_no         = module.security.bastion_acg_no
  server_image_name      = var.server_image_name
  server_hypervisor_type = var.server_hypervisor_type
  server_spec_code       = var.server_spec_code
}

// MARK: - Database Module

module "database" {
  source = "./modules/database" # NOTE: - 모듈 연결

  resource_prefix           = local.resource_prefix
  db_subnet_no              = module.network.db_subnet_no
  was_acg_no                = module.security.was_acg_no
  mysql_engine_version_code = var.mysql_engine_version_code
  mysql_generation_code     = var.mysql_generation_code
  mysql_user_name           = var.mysql_user_name
  mysql_user_password       = var.mysql_user_password
  mysql_user_host           = var.mysql_user_host
  mysql_database_name       = var.mysql_database_name
}

// MARK: - Load Balancer Module

module "loadbalancer" {
  source = "./modules/loadbalancer" // NOTE: - 모듈 연결

  resource_prefix        = local.resource_prefix
  vpc_no                 = module.network.vpc_no
  alb_subnet_no          = module.network.alb_subnet_no
  web_server_instance_no = module.compute.web_server_instance_no
}

