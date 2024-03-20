data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "eks_nodes_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "eks_cluster_role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLocalOutpostClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  ])

  policy_arn = each.value
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_node_role" {
  name               = "eks_node_role"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  ])

  policy_arn = each.value
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
}


resource "aws_subnet" "subnet1" {
  vpc_id                              = aws_vpc.vpc.id
  cidr_block                          = var.subnet_cidrs[0]
  availability_zone                   = var.availability_zones[0]
  map_public_ip_on_launch             = true
  private_dns_hostname_type_on_launch = "ip-name"
}

resource "aws_subnet" "subnet2" {
  vpc_id                              = aws_vpc.vpc.id
  cidr_block                          = var.subnet_cidrs[1]
  availability_zone                   = var.availability_zones[1]
  map_public_ip_on_launch             = true
  private_dns_hostname_type_on_launch = "ip-name"
}

resource "aws_subnet" "subnet3" {
  vpc_id                              = aws_vpc.vpc.id
  cidr_block                          = var.subnet_cidrs[2]
  availability_zone                   = var.availability_zones[2]
  map_public_ip_on_launch             = true
  private_dns_hostname_type_on_launch = "ip-name"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route_tb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_tb_assoc_1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_tb.id
}

resource "aws_route_table_association" "route_tb_assoc_2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route_tb.id
}

resource "aws_route_table_association" "route_tb_assoc_3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.route_tb.id
}

resource "aws_eks_cluster" "cluster" {
  name     = "${var.prefix}cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]
  }

  depends_on = [
    aws_iam_role.eks_cluster_role,
    aws_iam_role_policy_attachment.eks_cluster_role_policies
  ]
}

resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.prefix}nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]

  scaling_config {
    desired_size = var.node_count
    max_size     = var.node_count + 1
    min_size     = 0
  }

  instance_types = [var.cpu_arch == "x86" ? "m7i.2xlarge" : "m7g.2xlarge"]

  update_config {
    max_unavailable = var.node_count - 1
  }

  depends_on = [
    aws_iam_role.eks_cluster_role,
    aws_iam_role_policy_attachment.eks_cluster_role_policies,
    aws_iam_role.eks_node_role,
    aws_iam_role_policy_attachment.eks_node_role_policies
  ]
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name  = aws_eks_cluster.cluster.name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = "v1.28.0-eksbuild.1"
  depends_on = [ aws_eks_cluster.cluster, aws_eks_node_group.nodegroup, aws_eks_addon.vpc_cni, aws_eks_addon.coredns ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.cluster.name
  addon_name    = "vpc-cni"
  addon_version = "v1.16.0-eksbuild.1"
  depends_on = [ aws_eks_cluster.cluster, aws_eks_node_group.nodegroup ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.cluster.name
  addon_name    = "coredns"
  addon_version = "v1.11.1-eksbuild.4"
  depends_on = [ aws_eks_cluster.cluster, aws_eks_node_group.nodegroup ]
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.cluster.name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = aws_eks_cluster.cluster.name
}

resource "local_file" "cluster_config" {
  filename        = "${var.kube_config_path}/${aws_eks_cluster.cluster.name}-config.yml"
  file_permission = 600
  content         = <<EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${data.aws_eks_cluster.cluster.certificate_authority[0].data}
    server: ${data.aws_eks_cluster.cluster.endpoint}
  name: ${aws_eks_cluster.cluster.arn}
contexts:
- context:
    cluster: ${aws_eks_cluster.cluster.arn}
    user: ${aws_eks_cluster.cluster.arn}
  name: ${aws_eks_cluster.cluster.arn}
current-context: ${aws_eks_cluster.cluster.arn}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.cluster.arn}
  user:
    token: ${data.aws_eks_cluster_auth.cluster_auth.token}
- name: ${aws_eks_cluster.cluster.arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - ${var.region}
      - eks
      - get-token
      - --cluster-name
      - ${aws_eks_cluster.cluster.name}
      - --output
      - json
      command: aws
EOT
}
