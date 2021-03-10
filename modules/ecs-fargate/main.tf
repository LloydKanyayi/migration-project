#-----------ecs-fargate/main.tf


data "template_file" "my-first-app" {
  template = file("./template/ecs-task.json.tpl")
}



# creating a cluster for the ecs-fargate service

resource "aws_ecs_cluster" "main" {
  name = "myapp-cluster"
}


# creating a service for the ecs-fargate service



resource "aws_ecs_service" "main" {
  name            = "myapp-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = "my-first-app"
    container_port   = var.container_port
  }
  depends_on = [var.alb_listener_front_end, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}


# creating Task Definition for the ecs-fargate service

resource "aws_ecs_task_definition" "main" {
  family                   = "myapp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = data.template_file.my-first-app.rendered
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "my-app-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# creating Security group for ecs-fargate service

resource "aws_security_group" "ecs_tasks" {
  name   = "ecs-security"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.container_port
    to_port     = var.container_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

