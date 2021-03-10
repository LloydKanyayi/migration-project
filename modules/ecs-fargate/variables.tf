#----------ecs-fargate/variables.tf


variable "ecs_service_security_groups" {
  default = ""
}

variable "private_subnets" {}

variable "aws_alb_target_group_arn" {}


variable "container_port" {
  default = "80"
}

variable "vpc_id" {}