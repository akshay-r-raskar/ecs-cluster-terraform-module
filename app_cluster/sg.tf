locals {
  service_group_name = "${var.namespace}-app-sg"
}

resource "aws_security_group" "app_cluster_sg" {
  name = local.service_group_name

  tags = {
    Name = local.service_group_name
  }
}

resource "aws_security_group_rule" "egress_subnet" {
  security_group_id = aws_security_group.app_cluster_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}
