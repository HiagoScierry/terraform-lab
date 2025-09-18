output "website_endpoint" {
  description = "A URL do endpoint do site estático S3"
  value       = aws_s3_bucket_website_configuration.site_website.website_endpoint
}
output "bucket_name" {
  description = "O nome do bucket S3 criado"
  value       = aws_s3_bucket.site_bucket.bucket
}