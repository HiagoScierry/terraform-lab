output "api_endpoint_url" {
  description = "URL do endpoint do API Gateway para invocar a Lambda."
  value       = aws_apigatewayv2_stage.lambda_stage.invoke_url
}