 #-------------root/main.tf


 module "networking" {
   source = "./modules/networking"
   vpc_cidr = "10.123.0.0/16"
 }


 module "alb" {
   source = "./modules/alb"
   aws_vpc = module.networking.vpc_id
   public_subnets = module.networking.subnet_id_public
 }