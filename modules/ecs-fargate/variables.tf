#----------ecs-fargate/variables.tf

variable "name-cluster-" {
  default = ""
}


variable "name-service-" {
  default = ""
}

variable "ecs_service_security_groups" {
  default = ""
}


variable "subnets" {
  default = ""
}

variable "aws_alb_target_group_arn" {
  default = ""
}


variable "name-container-" {
  default = ""
}

variable "container_port" {
  default = ""
}