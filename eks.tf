#EKS

resource "aws_iam_role" "eks-iam-role" {
  name = "team4-eks-iam-role"

  assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role" "workernodes" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workernodes.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workernodes.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workernodes.name
}
resource "aws_eks_cluster" "team4-eks" {
  name     = "Team4-cluster"
  role_arn = aws_iam_role.eks-iam-role.arn
  vpc_config {
    subnet_ids = [aws_subnet.team4-pub1.id,aws_subnet.team4-pub2.id]
  }

  depends_on = [
     aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
     aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "t4worker-node-group" {
  cluster_name    = aws_eks_cluster.team4-eks.name
  node_group_name = "team4-workernodes"
  node_role_arn   = aws_iam_role.workernodes.arn
  subnet_ids      = [aws_subnet.team4-pub1.id,aws_subnet.team4-pub2.id]
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}