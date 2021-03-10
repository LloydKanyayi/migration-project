#---------------networking/outputs.tf


output "vpc_id" {
  description = "ID of EU-WEST-1 VPC"
  value       = aws_vpc.main.id
}

output "subnet_id_public" {
  value = aws_subnet.public.*.id
}

output "subnet_id_private" {
  value = aws_subnet.private.*.id
}