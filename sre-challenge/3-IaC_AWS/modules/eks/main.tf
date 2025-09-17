module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    default = {
      min_size       = 4
      max_size       = 4
      desired_size   = var.node_group_size
      instance_types = [var.node_instance_type]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
