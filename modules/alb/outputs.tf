# --------------alb/outputs.tf

output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.app.id
}

output "alb_listener_front_end" {
  value = aws_alb_listener.front_end
}