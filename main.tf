provider "aws" {
  region = "us-west-1"
  # profile = "myprofile"  
}


resource "aws_iam_role" "lambda_execution_role" {
  name = "my-lambda-execution-role-akshay"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = var.function_name
  handler      = "index.handler"
  runtime      = "python3.11"
  role        = aws_iam_role.lambda_execution_role.arn
  filename     = "${path.module}/stage-tag-script-peer.zip"  

  timeout      = 10
  memory_size = 128
}
