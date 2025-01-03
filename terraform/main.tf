provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}

#s3 bucket creation
# resource "aws_s3_bucket" "example" {
#     bucket = "hash-terraform-state-bucket"
#     tags = {
#         Name = "hash-terraform-state"
#     }
# }

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name    = "hash-cluster"
  cluster_version = "1.31"  
  subnet_ids      = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id

  cluster_endpoint_public_access  = true

  tags = {
    cluster = "demo"
  }

  eks_managed_node_group_defaults = {
    ami = "AL2_x86_64"
    instance_types = ["t2.micro"]
  }

  eks_managed_node_groups = {
    node_groups = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1  
    }
  }

}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  version = "~> 2.0"

  repository_name = "hash-iac-actions"
  registry_scan_type = "BASIC"
  repository_type = "private"
  repository_image_tag_mutability = "MUTABLE"
  
  repository_lifecycle_policy = jsonencode({
  rules = [
    {
      rulePriority = 1
      description  = "Retain all images"
      selection = {
        tagStatus  = "any"
        countType  = "imageCountMoreThan"
        countNumber = 100
      }
      action = {
        type = "expire"
      }
    }
  ]
})
  tags = {
    Terraform   = "true"
  }
}

