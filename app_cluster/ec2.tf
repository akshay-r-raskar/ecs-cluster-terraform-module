data "aws_ami" "latest_ecs" {
  most_recent = true
  owners      = ["591542846629"] # AWS

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "user_data_file" {
  template = <<EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.app_cluster.name} >> /etc/ecs/ecs.config

              yum -y update
              yum -y install https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

              yum -y install aws-cli
              
              EOF

}

resource "aws_launch_configuration" "launch_config" {

  image_id        = data.aws_ami.latest_ecs.id
  instance_type   = var.instance_type
  security_groups = ["${aws_security_group.app_cluster_sg.id}"]

  iam_instance_profile = "${aws_iam_instance_profile.ecs_cluster_instance_policy.id}"

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${base64encode(data.template_file.user_data_file.rendered)}"
}
