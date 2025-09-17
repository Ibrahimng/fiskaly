module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name                 = "eks-vpc"
  cidr                 = var.vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  private_subnets      = [for i in range(var.az_count) : "10.0.${i + 1}.0/24"]
  public_subnets       = [for i in range(var.az_count) : "10.0.${10 + i}.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "eks_api" {
  vpc_id = module.vpc.vpc_id
  name   = "eks-api-access"
  ingress {
    description = "Allow K8s API access from my IP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["86.106.20.118/32"] # Replace Public IP with the Yours IP by executing (curl -s 4 ifconfig.me) to get your IP
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
