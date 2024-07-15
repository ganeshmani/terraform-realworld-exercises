


output "lambda_function_url" {
  value = aws_lambda_function_url.lambda_fn_url.function_url
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.tf-lambda-users-ddb.name
}