#database_port = 3306
#spring_server_port = 8080

secret_params = [
  "BOANERGES_DB_HOST",
  "BOANERGES_DB_NAME",
  "BOANERGES_DB_USERNAME",
  "BOANERGES_DB_PASSWORD",
  "STS_ROLE_ARN",
  "DEEPGRAM_API_KEY",
  "DEEPGRAM_PROJECT_ID",
  "OPENAI_API_KEY",
  "SMTP_USERNAME",
  "SMTP_PASSWORD",
  "ACCESS_KEY_ID",
  "SECRET_ACCESS_KEY"
]

#secrets = [ for secret in var.secret_params:
#  {
#    name = secret,
#    valueFrom = data.aws_ssm_parameter.this[secret].arn
#  }
#]

env_vars = [
  {
    name  = "DB_PORT",
    value = 3306
  },
  {
    name  = "SPRING_SERVER_PORT",
    value = 8080
  }
]

services = [
  {
    service_name                = "boanerges-backend"
    task_name                   = "boanerges-backend"
    awslogs_group               = "boanerges-backend"
#    cluster_id                  = aws_ecs_cluster.boanerges.id
    container_image             = "ghcr.io/lerkasan/boanerges/boanerges-backend:latest"
    container_count             = 2
    container_cpu               = 256
    container_memory            = 512
    container_port              = 8080
#    ecs_task_role_arn           = aws_iam_role.backend_iam_role.arn
#    ecs_task_execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
#    env_vars                    = env_vars
#    secrets                     = secrets
    grace_period_in_seconds     = 1000
#    private_subnets_ids         = module.network.private_subnets_ids
#    security_group_ids          = [ module.security.backend_security_group_id ]
#    target_group_arn            = module.loadbalancer.backend_target_group_arn
    tmp_size_in_mb              = 512
  },
  {
    service_name                = "boanerges-frontend"
    task_name                   = "boanerges-frontend"
    awslogs_group               = "boanerges-frontend"
#    cluster_id                  = aws_ecs_cluster.boanerges.id
    container_image             = "ghcr.io/lerkasan/boanerges/boanerges-frontend:latest"
    container_count             = 2
    container_cpu               = 256
    container_memory            = 512
    container_port              = 8080
#    ecs_task_role_arn           = aws_iam_role.ecs_task_execution_role.arn
#    ecs_task_execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
#    env_vars                    = local.env_vars
#    secrets                     = local.secrets
    grace_period_in_seconds     = 1000
#    private_subnets_ids         = module.network.private_subnets_ids
#    security_group_ids          = [ module.security.frontend_security_group_id ]
#    target_group_arn            = module.loadbalancer.frontend_target_group_arn
    tmp_size_in_mb              = 512
  }

]