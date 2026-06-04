module "network" {

  source = "./modules/network"

  vpc_cidr        = var.vpc_cidr
  subnet_cidr     = var.subnet_cidr
  aws_region      = var.aws_region
  ssh_allowed_cidr = var.ssh_allowed_cidr
}

module "compute" {

  source = "./modules/compute"

  ami_id        = var.ami_id
  instance_type = var.instance_type

  subnet_id = module.network.subnet_id

  security_group_id = module.network.security_group_id
}