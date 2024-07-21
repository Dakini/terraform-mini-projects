resource "aws_iam_role" "test_service_lambda_role" {
  name = "${var.environment}-test_service_lambda_role"

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

resource "aws_iam_role_policy" "test_service_lambda_policy" {
  name = "${var.environment}-test_service_lambda_policy"
  role = aws_iam_role.test_service_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "logs:*",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "ecr:GetDownloadUrlForLayer",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "ecr:BatchCheckLayerAvailability",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "ecr:GetAuthorizationToken",
        Effect   = "Allow",
        Resource = "*",
      }
    ]
  })
}
output "lambda_image_uri" {
  description = "The URI of the Docker image used by the Lambda function."
  value       = "${aws_ecr_repository.test_service_ecr_repo.repository_url}:latest"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowExecutionFromApiGateway"
  action       = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_service_lambda_function.function_name
  principal    = "apigateway.amazonaws.com"
}

resource "aws_ecr_repository" "test_service_ecr_repo" {
  name                 = "${var.environment}-test_service_ecr_repo"
  image_tag_mutability = "MUTABLE"
}

resource "aws_lambda_function" "test_service_lambda_function" {
  function_name = "${var.environment}-test_service_lambda_function"
  timeout       = 60
  package_type   = "Image"
  role          = aws_iam_role.test_service_lambda_role.arn
  image_uri     = "${aws_ecr_repository.test_service_ecr_repo.repository_url}:latest"
}
