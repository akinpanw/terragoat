locals {
  eks_name = {
    value = "${local.resource_prefix.value}-eks"
  }
}

data aws_iam_policy_document "iam_policy_eks" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource aws_iam_role "iam_for_eks" {
  name               = "${local.resource_prefix.value}-iam-for-eks"
  assume_role_policy = data.aws_iam_policy_document.iam_policy_eks.json
  tags = {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/eks.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "de052596-21a0-43de-8153-469add277b18"
  }
}

resource aws_iam_role_policy_attachment "policy_attachment-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_for_eks.name
}

resource aws_iam_role_policy_attachment "policy_attachment-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iam_for_eks.name
}

resource aws_vpc "eks_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge({
    Name = "${local.resource_prefix.value}-eks-vpc"
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/eks.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "1600ca6c-72f6-45c0-a71d-88e117e51d6b"
  })
}

resource aws_subnet "eks_subnet1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.10.10.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = merge({
    Name                                            = "${local.resource_prefix.value}-eks-subnet"
    "kubernetes.io/cluster/${local.eks_name.value}" = "shared"
    }, {
    git_commit                                       = "6e62522d2ab8f63740e53752b84a6e99cd65696a"
    git_file                                         = "terraform/aws/eks.tf"
    git_last_modified_at                             = "2021-05-02 11:16:31"
    git_last_modified_by                             = "nimrodkor@gmail.com"
    git_modifiers                                    = "nimrodkor"
    git_org                                          = "bridgecrewio"
    git_repo                                         = "terragoat"
    "kubernetes.io/cluster/$${local.eks_name.value}" = "shared"
    yor_trace                                        = "1fb4fa23-a5d6-4d6a-b7dc-88749383f48d"
    }, {
    "kubernetes.io/cluster/$$${local.eks_name.value}" = "shared"
    "kubernetes.io/cluster/$${local.eks_name.value}"  = "shared"
    }, {
    "kubernetes.io/cluster/$$$${local.eks_name.value}" = "shared"
    "kubernetes.io/cluster/$$${local.eks_name.value}"  = "shared"
    "kubernetes.io/cluster/$${local.eks_name.value}"   = "shared"
  })
}

resource aws_subnet "eks_subnet2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.10.11.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
  tags = merge({
    Name                                            = "${local.resource_prefix.value}-eks-subnet2"
    "kubernetes.io/cluster/${local.eks_name.value}" = "shared"
    }, {
    git_commit                                       = "6e62522d2ab8f63740e53752b84a6e99cd65696a"
    git_file                                         = "terraform/aws/eks.tf"
    git_last_modified_at                             = "2021-05-02 11:16:31"
    git_last_modified_by                             = "nimrodkor@gmail.com"
    git_modifiers                                    = "nimrodkor"
    git_org                                          = "bridgecrewio"
    git_repo                                         = "terragoat"
    "kubernetes.io/cluster/$${local.eks_name.value}" = "shared"
    yor_trace                                        = "9ce04af2-5321-4e6c-a262-e4d7c1f69525"
    }, {
    "kubernetes.io/cluster/$$${local.eks_name.value}" = "shared"
    "kubernetes.io/cluster/$${local.eks_name.value}"  = "shared"
    }, {
    "kubernetes.io/cluster/$$$${local.eks_name.value}" = "shared"
    "kubernetes.io/cluster/$$${local.eks_name.value}"  = "shared"
    "kubernetes.io/cluster/$${local.eks_name.value}"   = "shared"
  })
}

resource aws_eks_cluster "eks_cluster" {
  name     = local.eks_name.value
  role_arn = "${aws_iam_role.iam_for_eks.arn}"

  vpc_config {
    endpoint_private_access = true
    subnet_ids              = ["${aws_subnet.eks_subnet1.id}", "${aws_subnet.eks_subnet2.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.policy_attachment-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.policy_attachment-AmazonEKSServicePolicy",
  ]
  tags = {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/eks.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "7fa14261-c18d-4fa2-aec4-746f6e64d2d3"
  }
}

output "endpoint" {
  value = "${aws_eks_cluster.eks_cluster.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.eks_cluster.certificate_authority.0.data}"
}

resource "aws_instance" "web_host" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
  "${aws_security_group.web-node.id}"]
  subnet_id = "${aws_subnet.web_subnet.id}"
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = merge({
    Name = "${local.resource_prefix.value}-ec2"
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "347af3cd-4f70-4632-aca3-4d5e30ffc0b6"
  })
}
