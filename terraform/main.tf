module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = "10.0.0.0/16"
  project_name = "financial-platform"
}

module "eks" {
  source = "./modules/eks"

  cluster_name = "financial-platform-eks"
  project_name = "financial-platform"

  subnet_ids = module.vpc.public_subnet_ids
}
