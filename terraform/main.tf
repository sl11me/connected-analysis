provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "ia-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.my_subnets[*].id
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "ia-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

# VPC pour cluster EKS
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ia-eks-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "ia-eks-igw"
  }
}

# Sous-réseaux publics pour EKS
resource "aws_subnet" "my_subnets" {
  count = 2

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = "us-east-1${count.index == 0 ? "a" : "b"}"

  map_public_ip_on_launch = true

  tags = {
    Name                     = "ia-eks-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
}

# Route table pour les sous-réseaux publics
resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "ia-eks-public-rt"
  }
}

# Association des sous-réseaux avec la route table
resource "aws_route_table_association" "my_subnet_association" {
  count = 2

  subnet_id      = aws_subnet.my_subnets[count.index].id
  route_table_id = aws_route_table.my_public_rt.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.my_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.my_cluster.certificate_authority[0].data
}
