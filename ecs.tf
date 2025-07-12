resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${jupiter}-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}