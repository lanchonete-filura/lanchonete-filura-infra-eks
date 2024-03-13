terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.52.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_eks_cluster" "lanchonete_filura_cluster" {
  name     = "lanchonete_filura_cluster"
  role_arn = aws_iam_role.lanchonete_filura_cluster_role-resource.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tags = {
    Environment = "test"
    prod = "true"
  }
}

resource "aws_iam_role" "lanchonete_filura_cluster_role-resource" {
  name = "lanchonete_filura_cluster_role-resource"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [{
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "eks.amazonaws.com"
      },
      "Action" = "sts:AssumeRole"
    }]
  })
}

resource "aws_eks_node_group" "lanchonete_filura_cluster_nodes" {
  cluster_name    = aws_eks_cluster.lanchonete_filura_cluster.name
  node_group_name = "lanchonete_filura_cluster_nodes"
  node_role_arn   = aws_iam_role.lanchonete_filura_cluster_role-resource.arn

  subnet_ids = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  tags = {
    Environment = "test"
  }
}

resource "aws_iam_role" "lanchonete_filura_node_group_role-resource" {
  name = "lanchonete_filura_node_group_role-resource"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [{
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "ec2.amazonaws.com"
      },
      "Action" = "sts:AssumeRole"
    }]
  })
}

resource "aws_eks_fargate_profile" "lanchonete_filura_fargate_profile" {
  cluster_name           = aws_eks_cluster.lanchonete_filura_cluster.name
  fargate_profile_name   = "lanchonete_filura_fargate_profile"
  pod_execution_role_arn = aws_iam_role.lanchonete_filura_fargate_profile_role-resource.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "lanchonete-filura-core"
  }
}

resource "aws_iam_role" "lanchonete_filura_fargate_profile_role-resource" {
  name = "lanchonete_filura_fargate_profile_role-resource"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "lanchonete-filura-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.lanchonete_filura_fargate_profile_role-resource.name
}
