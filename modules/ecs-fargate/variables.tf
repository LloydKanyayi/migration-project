#----------ecs-fargate/variables.tf


variable "private_subnets" {}

variable "aws_alb_target_group_arn" {}


variable "container_port" {
  default = "80"
}

variable "vpc_id" {
  type = string
}


variable "alb_listener_front_end" {}


