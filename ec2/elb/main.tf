resource "aws_lb" "foodstore-alb-tf" {
  name               = "foodstore-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.foodstore-lb-sg.id]
  subnets            = [data.terraform_remote_state.vpc.outputs.public_subnet_id]

  tags = {
    Name = "foodstore-alb"
  }
}

resource "aws_lb_target_group" "foodstore-tg-tf" {
  name     = "foodstore-tg-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "foodstore-tg-tf"
  }
}

resource "aws_lb_listener" "foodstore-listener" {
  load_balancer_arn = aws_lb.foodstore-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.foodstore-tg-tf.arn
  }
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.foodstore-alb-tf.dns_name
}
