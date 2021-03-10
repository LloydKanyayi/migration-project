# --------------alb/main.tf.tf


resource "aws_alb" "main" {
  name               = "myapp-load-balancer"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.lb.id]
  load_balancer_type = "application"

  tags = {
    Name = "main-alb"
  }
}

# Redirect all traffic from the ALB to the target group

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}


# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "myapp-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = var.aws_vpc

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_alb_target_group" "app" {
  name        = "myapp-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc
  target_type = "ip"

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

