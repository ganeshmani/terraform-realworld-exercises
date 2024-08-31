variable "ecr_repo_proxy_url" {
  description = "ECR repository URL"
  type = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type = string
}

variable "ecr_repository_tag" {
  description = "ECR repository tag"
  type = string
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type = string
}