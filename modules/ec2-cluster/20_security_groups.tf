# The AWS provider removes the default "allow all "egress rule from all security
# groups, so it has to be defined explicitly.
resource "aws_security_group" "egress" {
  name        = "${var.cluster_name}-egress"
  description = "Allow all outgoing traffic to everywhere"
  vpc_id      = aws_vpc.this.id
  tags        = local.tags
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_internal" {
  name        = "${var.cluster_name}-ingress-internal"
  description = "Allow all incoming traffic from nodes and Pods in the cluster"
  vpc_id      = aws_vpc.this.id
  tags        = local.tags
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    self        = true
    description = "Allow incoming traffic from cluster nodes"

  }
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.pod_network_cidr_block != null ? [var.pod_network_cidr_block] : null
    description = "Allow incoming traffic from the Pods of the cluster"
  }
}

resource "aws_security_group" "ingress_ssh" {
  name        = "${var.cluster_name}-ingress-ssh"
  description = "Allow incoming SSH traffic (TCP/22) from outside the cluster"
  vpc_id      = aws_vpc.this.id
  tags        = local.tags
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }
}

resource "aws_security_group" "ingress_https" {
  name        = "${var.cluster_name}-ingress-https"
  description = "Allow incoming HTTPS traffic (TCP/443) from outside the cluster"
  vpc_id      = aws_vpc.this.id
  tags        = local.tags
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}
