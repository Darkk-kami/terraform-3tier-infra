module "security_group" {
  source                = "../shared/security_groups"
  vpc_id                = var.vpc_id
  allow_internet_access = true
}

resource "aws_lb" "alb" {
  name               = "${var.environment}-web-server-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security_group.security_group_id]
  subnets            = var.alb_subnets
}

resource "aws_lb_target_group" "asg_target_group" {
  name     = "${var.environment}-asg-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_target_group.arn
  }
}
