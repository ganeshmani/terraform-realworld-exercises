variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type = string
}

variable "ecr_repository_url_proxy" {
  description = "ECR repository URL for proxy"
  type = string 
  default = ""
}

variable "ecr_repository_tag" {
  description = "ECR repository tag"
  type = string
  default = "latest"
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type = string
  default = "web-api"
}