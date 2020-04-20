resource "aws_autoscaling_group" "app_cluster_auto_scale" {

  name                 = "app_cluster_auto_scale"
  launch_configuration = "${aws_launch_configuration.launch_config.name}"
  vpc_zone_identifier  = var.subnet_ids
  min_size             = 3
  max_size             = 3

  health_check_grace_period = 300
  health_check_type         = "EC2"

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    { key = "Name", value = "ddp_poc_app_cluster_node", propagate_at_launch = true }
  ]
}
