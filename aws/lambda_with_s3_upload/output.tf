output "api_endpoint_url" {
  description = "URL do endpoint do API Gateway para invocar a Lambda."
  value       = aws_apigatewayv2_stage.lambda_stage.invoke_url
}

output "s3_bucket_name" {
  description = "Nome do bucket S3 onde o código da Lambda está armazenado."
  value       = aws_s3_bucket.lambda_code_bucket.id
}