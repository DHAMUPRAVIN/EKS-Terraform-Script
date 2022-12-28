resource "aws_eks_cluster" "My-cluster" {
  name     = "beast"
  role_arn = aws_iam_role.eks_master_role.arn
  version  = "1.24"

  vpc_config {
    subnet_ids              = ["subnet-0b671f7fd0510xxx", "subnet-0cd793aa2048a9xx"]
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = ["0.0.0.0/0"]

  }

  #kubernetes_network_config {
  #  service_ipv4_cidr = "192.168.X.X/16"
  #}

  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}