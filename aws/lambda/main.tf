terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../apps/lambda_app"
  output_path = "${path.module}/dist/lambda_function.zip"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.app_name}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda_simple_file_upload" {
  function_name = var.app_name
  role          = aws_iam_role.lambda_exec_role.arn

  filename      = data.archive_file.lambda_zip.output_path
  # O source_code_hash garante que a Lambda seja atualizada sempre que o código no arquivo zip mudar.
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # Configurações do runtime
  handler = "index.handler" # arquivo_sem_extensão.função_exportada
  runtime = "nodejs20.x"    # Use uma versão LTS do Node.js

  timeout     = 10 # Tempo máximo de execução em segundos
  memory_size = 128 # Memória em MB

  tags = {
    ManagedBy = "Terraform"
    Project   = var.app_name
  }
}

resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "${var.app_name}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "$default" # Cria um stage padrão que é invocado automaticamente
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.lambda_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda_simple_file_upload.invoke_arn
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "ANY /{proxy+}" # Captura qualquer método (GET, POST, etc.) em qualquer caminho
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Permissão para que o API Gateway possa invocar a função Lambda
resource "aws_lambda_permission" "api_gw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_simple_file_upload.function_name
  principal     = "apigateway.amazonaws.com"

  # Garante que a permissão se aplique a qualquer rota da nossa API
  source_arn = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}
