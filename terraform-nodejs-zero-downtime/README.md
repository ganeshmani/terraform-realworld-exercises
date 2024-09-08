# Zero-Downtime Deployments for Node.js Applications

## Overview

This repository provides a complete setup for deploying a Node.js application using AWS ECS (Elastic Container Service) with zero-downtime deployments. The infrastructure is managed using Terraform, and the application is containerized using Docker. This setup ensures that your application remains available during updates.

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Deployment](#deployment)
- [Usage](#usage)
- [License](#license)

## Features

- Zero-downtime deployments using AWS ECS and Application Load Balancer (ALB).
- Infrastructure as Code (IaC) with Terraform.
- Dockerized Node.js application.
- Integration with AWS CloudWatch for logging.
- Local development with DynamoDB.

## Architecture

The architecture consists of the following components:

- **VPC**: A Virtual Private Cloud to host the application.
- **Subnets**: Two subnets in different availability zones for high availability.
- **ECS Cluster**: Hosts the ECS service running the Node.js application.
- **ECS Service**: Manages the deployment of the application.
- **Application Load Balancer**: Distributes incoming traffic to the ECS service.
- **CloudWatch Logs**: Captures logs from the ECS tasks.
- **DynamoDB**: A NoSQL database for storing user data.

## Getting Started

### Prerequisites

- AWS account
- AWS CLI configured
- Terraform installed
- Docker installed

### Clone the Repository

```bash
git clone https://github.com/yourusername/terraform-nodejs-zero-downtime.git
cd terraform-nodejs-zero-downtime
```

### Configure Environment Variables

Create a `.env` file in the root directory and add the following variables:

```
AWS_ACCOUNT_ID=your_aws_account_id
AWS_REGION=us-east-1
ECR_REPOSITORY=your_ecr_repository_name
ECR_REPOSITORY_URI=your_ecr_repository_uri
```

## Deployment

### Build and Push Docker Image

1. Build the Docker image and push it to AWS ECR:

```bash
docker build -t your_ecr_repository_name .
docker tag your_ecr_repository_name:latest your_aws_account_id.dkr.ecr.us-east-1.amazonaws.com/your_ecr_repository_name:latest
docker push your_aws_account_id.dkr.ecr.us-east-1.amazonaws.com/your_ecr_repository_name:latest
```

### Deploy with Terraform

1. Navigate to the `infra` directory:

```bash
cd infra
```

2. Initialize Terraform:

```bash
terraform init
```

3. Plan the deployment:

```bash
terraform plan
```

4. Apply the changes:

```bash
terraform apply
```

## Usage

Once the deployment is complete, you can access the application via the ALB URL provided in the Terraform output. The application exposes the following endpoints:

- `GET /`: Returns a welcome message.
- `GET /health`: Returns the health status of the application.
- `POST /user`: Creates a new user (requires a JSON body with user details).
