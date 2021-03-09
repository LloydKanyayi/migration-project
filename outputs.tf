#-------------root/outputs.tf


output "vpc_id" {
  description = "ID of EU-WEST-1 VPC"
  value = module.networking.vpc_id
}

output "subnet_id_public" {
  value = module.networking.subnet_id_public
}

output "subnet_id_private" {
  value = module.networking.subnet_id_private
}
