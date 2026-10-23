# Fetch the active availability zones available in us-east-1
data "aws_availability_zones" "available" {}

# Create a secure, isolated VPC Network for the EKS Cluster
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "capstone-voting-vpc"
  cidr = "10.0.0.0/16"

  # Divide subnets across two distinct availability zones
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # Enable NAT Gateways so private nodes can pull external Docker images safely
  enable_nat_gateway = true
  single_nat_gateway = true

  # Add explicit tagging metadata required by the AWS EKS Controller
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Environment = "production"
    Project     = "capstone-voting"
  }
}
