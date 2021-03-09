# # --------------alb/main.tf.tf

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "main-alb"
  }
}