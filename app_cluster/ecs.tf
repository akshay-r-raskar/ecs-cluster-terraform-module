resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.namespace}-app_cluster"

  tags = {
    Name = "${var.namespace}-app_cluster"
  }
}

resource "aws_ecs_task_definition" "ddp_poc_streams_app_td" {
  family                   = "ddp_poc_streams_app"
  container_definitions    = file("streams_app_taskdef.json")
  memory                   = 1024
  requires_compatibilities = ["EC2"]
}


resource "aws_ecs_service" "ddp_poc_streams_app" {
  name            = "ddp_poc_streams_app"
  cluster         = "${aws_ecs_cluster.app_cluster.id}"
  task_definition = "${aws_ecs_task_definition.ddp_poc_streams_app_td.arn}"
  desired_count   = 3
  launch_type     = "EC2"
}
