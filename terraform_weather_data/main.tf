provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "weather-data-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
