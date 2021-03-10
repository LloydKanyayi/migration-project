#------------------alb/variables.tf


variable "public_subnets" {}

variable "aws_vpc" {}


variable "app_port" {
  default = "80"
}