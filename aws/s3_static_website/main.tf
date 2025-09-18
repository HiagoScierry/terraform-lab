terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "site_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "site_website" {
  bucket = aws_s3_bucket.site_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_public_access_block" "site_public_access" {
  bucket = aws_s3_bucket.site_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.site_bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.site_public_access]
}

locals {
  site_source_dir = "${path.module}/../../apps/html"

  site_files = fileset(local.site_source_dir, "**/*")

  mime_types = {
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "gif"  = "image/gif"
    "svg"  = "image/svg+xml"
    "ico"  = "image/x-icon"
    "json" = "application/json"
  }
}

resource "aws_s3_object" "site_files" {
  for_each = local.site_files

  bucket = aws_s3_bucket.site_bucket.id
  key    = each.value
  source = "${local.site_source_dir}/${each.value}"
  etag   = filemd5("${local.site_source_dir}/${each.value}")

  # --- CORREÇÃO DO CONTENT_TYPE ---
  # 1. 'try' tenta executar a regex. Se falhar (ex: arquivo sem extensão), usa ""
  # 2. 'regex' extrai a extensão do arquivo (ex: "css" de "style.css")
  # 3. 'lookup' procura a extensão no mapa 'local.mime_types'
  # 4. Se não encontrar, usa "application/octet-stream" como padrão
  content_type = lookup(
    local.mime_types,
    try(regex("\\.([^.]+)$", each.value)[0], ""),
    "application/octet-stream"
  )
}