resource "aws_security_group" "api" {
  name        = "api"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "execution_role" {
  name = "bibek-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "bibek-ecsTaskExecutionRole"
  }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.execution_role.arn

  container_definitions = jsonencode([{
    name  = "api"
    image = "bibek65/3tier:stable-image"
    portMappings = [{
      containerPort = 5000
      hostPort      = 5000
      protocol      = "tcp"
    }]
  }])
}

resource "aws_ecs_service" "api" {
  name    = "api"
  cluster = module.ecs.this_ecs_cluster_arn

  task_definition = aws_ecs_task_definition.api.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc_subnet_module.public_subnets
    security_groups  = [aws_security_group.api.id]
    assign_public_ip = true
  }
  desired_count = 1
}


