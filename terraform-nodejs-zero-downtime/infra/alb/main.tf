module "vpc" {
  source = "../vpc"
} 


resource "aws_security_group" "load_balancer_sg" {
    vpc_id = "${module.vpc.vpc.id}"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb_target_group" "alb_target_group" {
  # name = "alb-target-group-node-app-${var.environment}"
  port = 8080
  protocol = "HTTP"
  target_type = "ip"
  name_prefix = "alb-tg" // This is a prefix for the target group name and explain it why
  vpc_id = "${module.vpc.vpc.id}"

  health_check {
    path = "/health"
  }

   lifecycle {
    create_before_destroy = true // why do we need this?
  }
}

resource "aws_lb_listener" "listener" {
 load_balancer_arn = "${aws_alb.app_load_balancer.arn}" # Referencing our load balancer

  port              = 80 # 443
  protocol          = "HTTP" # HTTPS

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}" # Referencing our tagrte group
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}

resource "aws_security_group" "ecs_service_security_group" {
  vpc_id = "${module.vpc.vpc.id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = ["${aws_security_group.load_balancer_sg.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "app_load_balancer" {
  name = "ecs-web-api-alb"
  load_balancer_type = "application"

  subnets = [ 
    "${module.vpc.default_subnet_ab}",
    "${module.vpc.default_subnet_ac}"
   ]

  security_groups = [ 
    "${aws_security_group.load_balancer_sg.id}",
   ]
}