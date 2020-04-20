# Instance Policy
# -- Role
#    -- Default Policy (assumeRole)
#    -- Policy attachments (cloudwatch, )

# Default policy for the role

resource "aws_cloudwatch_log_group" "app_cluster_log_group" {
  name              = "/ecs/app_cluster_logs"
  retention_in_days = 7
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "cloudwatch_policy_document" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.app_cluster_log_group.arn}"
    ]
  }
}

# Policy 
resource "aws_iam_policy" "cloud_watch_policy" {
  name   = "cloud_watch_policy"
  policy = data.aws_iam_policy_document.cloudwatch_policy_document.json
}

# Policy attachments
resource "aws_iam_role_policy_attachment" "permission_for_cloudwatch" {
  role       = aws_iam_role.ecs_cluster_role.name
  policy_arn = aws_iam_policy.cloud_watch_policy.arn
}

resource "aws_iam_role_policy_attachment" "permission_for_ssm" {
  role       = aws_iam_role.ecs_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "permission_for_container_to_assume_ec2" {
  role       = aws_iam_role.ecs_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# Role
resource "aws_iam_role" "ecs_cluster_role" {
  name               = "ecs_cluster_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_instance_profile" "ecs_cluster_instance_policy" {
  name = "ecs_cluster_instance_policy"
  role = aws_iam_role.ecs_cluster_role.name
}
