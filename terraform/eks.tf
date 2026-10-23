# Provision the Amazon EKS Managed Kubernetes Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "capstone-voting-cluster"
  cluster_version = "1.31"

  # Allow the cluster control plane to use public API endpoints for easier admin control
  cluster_endpoint_public_access = true

  # Attach the EKS cluster directly to our newly created subnets
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Configure Managed Node Groups (The underlying EC2 servers where your containers live)
  eks_managed_node_groups = {
    worker_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      # Use standard general-purpose instance types that bypass the spot-combination policy constraints
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "production"
    Project     = "capstone-voting"
  }
}
