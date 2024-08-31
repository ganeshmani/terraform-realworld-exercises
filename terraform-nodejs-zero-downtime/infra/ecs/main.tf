module "ecs_task_logs" {
  source = "../cloudwatch"
}

module "vpc" {
  source = "../vpc"
}

module "alb" {
  source = "../alb"
}

resource "aws_ecs_task_definition" "ecs-nodejs-api-task-definition" {
    family = "ecs-nodejs-api-task"
    container_definitions = <<DEFINITION
    [
    {
        "name": "web-api",
        "image": "${var.ecr_repository_url}:${var.ecr_repository_tag}",
        "essential": true,
        "portMappings": [
            {
                "containerPort": 8080,
                "hostPort": 8080
            }
        ],
        "memory": 512,
        "cpu": 256,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${module.ecs_task_logs.log_group_name}",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "web-api"
        }
      }
    }
    ]
    DEFINITION
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    memory = 2048
    cpu = 1024
    execution_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}


resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRoleWebAPI"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-web-api-cluster"
}

resource "aws_ecs_service" "ecs-nodejs-api-service" {
  name = "ecs-nodejs-api-service"
  cluster = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.ecs-nodejs-api-task-definition.arn}"
  launch_type = "FARGATE"
  desired_count = 1

  load_balancer {
    target_group_arn = "${module.alb.alb_target_group.arn}"
    container_name = "web-api"
    container_port = 8080
  }

  network_configuration {
    subnets = ["${module.vpc.default_subnet_ab}", "${module.vpc.default_subnet_ac}"]
    security_groups = ["${module.alb.ecs_service_security_group_id.id}"]
    assign_public_ip = true
  }
}

