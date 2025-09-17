module "network" {
  source   = "../modules/network"
  vpc_cidr = var.vpc_cidr
  az_count = var.az_count
}

module "eks" {
  source             = "../modules/eks"
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = module.network.vpc_id
  private_subnets    = module.network.private_subnets
  public_subnets     = module.network.public_subnets
  node_group_size    = var.node_group_size
  node_instance_type = var.node_instance_type
}
