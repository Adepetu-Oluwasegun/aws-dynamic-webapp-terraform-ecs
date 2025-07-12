resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                    = "${}-task-definition"
  execution_role_arn        = 
  network_mode              = 
  requires_compatibilities  = []
  cpu                       = 
  memory                    = 

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions     = jsonencode([
    {
      name                  = "${}-container"
      image                 = 
      essential             = true

      portMappings          = [
        {
          containerPort     = 
          hostPort          = 
        }
      ]
      
      ulimits = [
        {
          name = "nofile",
          softLimit = 1024000,
          hardLimit = 1024000
        }
      ]

      logConfiguration = {
        logDriver   = "awslogs",
        options     = {
          "awslogs-group"          = 
           "awslogs-region"        = 
          "awslogs-stream-prefix"  = 
        }
      }
    }
  ])
}