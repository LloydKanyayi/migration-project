# # --------------alb/main.tf.tf



resource "aws_alb" "main" {
  name               = "myapp-target-group"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "main-alb"
  }
}


resource "aws_lb_target_group" "app" {
    name        = "myapp-target-group"
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = var.aws_vpc

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.id
  }
}


# ALB Security Group: Edit to restrict access to the application

resource "aws_security_group" "lb" {
  description = "Allow inbound traffic"
  vpc_id      = var.aws_vpc

  ingress {
    description = "TLS from VPC"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb"
  }
}