#-----------ecs-fargate/main.tf


data "template_file" "firstapp"{
  template = file("./modules/ecs-fargate")
}



# creating a cluster for the ecs-fargate service

resource "aws_ecs_cluster" "main" {
  name = var.name-cluster-"${var.environment}"
}


# creating a service for the ecs-fargate service

resource "aws_ecs_service" "main" {
  name = var.name-service-"${var.environment}"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent = 200
  launch_type = "FARGATE"
  scheduling_strategy = "REPLICA"

  network_configuration {
    security_groups = var.ecs_service_security_groups
    subnets = var.subnets.*.id
    assign_public_ip = false
}

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name = var.name-container-"${var.environment}"
    container_port = var.container_port
}

lifecycle {
ignore_changes = [task_definition, desired_count]
}

}

# --------------ecs-fargate/main.tf

# creating Task Definition for the ecs-fargate service
resource "aws_ecs_task_definition" "main" {
  family = "myapp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = data.template_file.firstapp.rendered
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.name-"ecsTaskExecutionRole"

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
name   = "${var.name}-sg-task-${var.environment}"
vpc_id = var.vpc_id

ingress {
protocol         = "tcp"
from_port        = var.container_port
to_port          = var.container_port
cidr_blocks      = ["0.0.0.0/0"]
}

egress {
protocol         = "-1"
from_port        = 0
to_port          = 0
cidr_blocks      = ["0.0.0.0/0"]
}
}

