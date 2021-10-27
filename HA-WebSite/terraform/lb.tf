#In this template we are creating aws application laadbalancer
#and target group and alb http/https listeners

resource "aws_alb" "web" {
  idle_timeout    = "30"
  name            = "wave-alb"
  security_groups = [aws_security_group.lb-sg.id]
  subnets         = aws_subnet.private.*.id
  depends_on      = [aws_instance.bastion]
  
  tags            = {
    Name          = "wave-alb"
  }
}
 
resource "aws_alb_listener" "testapp" {
  default_action {
    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    type = "redirect"
  }
 
  load_balancer_arn = aws_alb.web.id
  port              = "80"
  protocol          = "HTTP"
}
 
resource "aws_alb_listener" "alb_listener_https" {
  certificate_arn = "arn:aws:acm:us-east-1:122734987158:certificate/28db2c31-26c8-4cb1-8328-bdb8cf89bff8"
 
  default_action {
    target_group_arn = aws_alb_target_group.myapp-tg.arn
    type             = "forward"
  }
 
  load_balancer_arn = aws_alb.web.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
}
resource "aws_alb_target_group" "myapp-tg" {
  name        = "myapp-tg"
  port        = var.app_port
  protocol    = "HTTP"
  slow_start  = "0"
  depends_on  = [aws_instance.bastion]
  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
  }

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    interval            = "6"
    matcher             = "200,301,302"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
  }
 
  target_type = "instance"
  vpc_id      = aws_vpc.wave-vpc.id
}

#--------------------------------------------------
output "web_loadbalancer_url" {
  value = aws_alb.web.dns_name
}