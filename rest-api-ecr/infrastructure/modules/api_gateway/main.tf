resource "aws_api_gateway_rest_api" "rest_api_name" {
  name = var.rest_gateway_name
}

resource "aws_api_gateway_resource" "api_resource" {
  parent_id   = aws_api_gateway_rest_api.rest_api_name.root_resource_id
  path_part   = var.path_part
  rest_api_id = aws_api_gateway_rest_api.rest_api_name.id
}

resource "aws_api_gateway_method" "post_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api_name.id
  }

resource "aws_api_gateway_integration" "lambda_integration" {
  http_method = aws_api_gateway_method.post_method.http_method
  resource_id = aws_api_gateway_resource.api_resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api_name.id
  type        = "AWS"
  integration_http_method = "POST"
  uri = var.lambda_function_arn
}

resource "aws_api_gateway_method_response" "proxy" {
    http_method = aws_api_gateway_method.post_method.http_method
    resource_id = aws_api_gateway_resource.api_resource.id
    rest_api_id = aws_api_gateway_rest_api.rest_api_name.id
    status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy" {
    http_method = aws_api_gateway_method.post_method.http_method
    resource_id = aws_api_gateway_resource.api_resource.id
    rest_api_id = aws_api_gateway_rest_api.rest_api_name.id
    status_code = aws_api_gateway_method_response.proxy.status_code

    depends_on = [ aws_api_gateway_method.post_method, aws_api_gateway_integration.lambda_integration ]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_name.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_resource.id,
      aws_api_gateway_method.post_method.id,
      aws_api_gateway_integration.lambda_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api_name.id
  stage_name    = var.stage_name
}

output "invoke_arn" {
  value = "${aws_api_gateway_stage.stage.invoke_url}/${var.path_part}"
}