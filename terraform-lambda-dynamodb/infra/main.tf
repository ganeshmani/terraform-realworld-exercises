


# data "archive_file" "lambda" {
#   type        = "zip"
#   # source_dir  = "${path.module}/../app/build"
#   # source_file = "lambda.js"
#   output_path = "${path.module}/../app/terraform-lambda-dynamodb.zip"
# }


data "aws_iam_policy_document" "tf-lambda-dynamodb" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
    name = "tf-lambda-dynamodb"
    assume_role_policy = data.aws_iam_policy_document.tf-lambda-dynamodb.json
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "tf-lambda-dynamodb"
  role = aws_iam_role.lambda_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
  }
EOF
}

resource "aws_dynamodb_table" "tf-lambda-users-ddb" {
  name = "Users"
  billing_mode = "PROVISIONED"
  read_capacity = 20
  write_capacity = 20
  hash_key = "userId"


  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name = "email-index"
    hash_key = "email"
    projection_type = "ALL"

    write_capacity = 10
    read_capacity = 10
  }


  tags = {
    Name = "tf-lambda-users-ddb"

  }
}



resource "aws_lambda_function" "lambda_fn" {
  filename = "${path.module}/../app/terraform-lambda-dynamodb.zip"
  function_name = "tf-lambda-dynamodb"
  role = aws_iam_role.lambda_role.arn
  handler = "build/lambda.handler"

  source_code_hash = filebase64sha256("${path.module}/../app/terraform-lambda-dynamodb.zip")

  runtime = "nodejs18.x"

  timeout = 15
  memory_size = 128
  environment {
    variables = {
      NODE_ENV = "production"
    }
  }
}


resource "aws_lambda_function_url" "lambda_fn_url" {
  function_name = aws_lambda_function.lambda_fn.function_name
  authorization_type = "NONE"
}