
# Create the VPC and networking
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs = ["${var.aws_region}a", "${var.aws_region}b"]

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Project   = var.project_name
    Terraform = "true"
  }
}

# Create the EKS cluster and managed worker nodes
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.26.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    general = {
      name           = "${var.project_name}-workers"
      instance_types = [var.node_instance_type]

      min_size     = 1
      max_size     = 2
      desired_size = var.desired_nodes
    }
  }

  tags = {
    Project   = var.project_name
    Terraform = "true"
  }
}
