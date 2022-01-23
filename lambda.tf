provider "aws" {
  region = "us-east-2"
}

terraform {
  required_providers {
    archive = "~> 1.3"
  }
}
resource "aws_iam_role" "test_lambda" {
  name = "test_lambda"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.test_lambda.arn
  handler       = "index.test"
 source_code_hash = filebase64sha256("lambda_function_payload.zip")
runtime = "python3.9"
}
