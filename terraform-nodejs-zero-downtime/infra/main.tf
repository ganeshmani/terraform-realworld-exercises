

module "web-api" {
  source = "./ecs"
  aws_region = var.aws_region
  ecr_repository_url = var.ecr_repository_url
  ecr_repo_proxy_url = var.ecr_repository_url_proxy
  ecr_repository_tag = var.ecr_repository_tag
}