#-------------root/outputs.tf


output "vpc_id" {
  description = "ID of EU-WEST-1 VPC"
  value       = module.networking.vpc_id
}

output "subnet_id_public" {
  value = module.networking.subnet_id_public
}

output "subnet_id_private" {
  value = module.networking.subnet_id_private
}

output "aws_alb_target_group_arn" {
  value = module.alb.aws_alb_target_group_arn
}

output "alb_listener_front_end" {
  value = module.alb.alb_listener_front_end
}