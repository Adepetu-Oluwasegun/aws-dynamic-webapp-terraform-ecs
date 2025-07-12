# create ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${jupiter}-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

# create cloudwatch log group
resource "aws_cloudwatch_log_group" "log_group" {
  name = "${jupiter}-task-definition"
  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
  }
}