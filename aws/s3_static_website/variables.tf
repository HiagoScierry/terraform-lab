variable "aws_region" {
  description = "Região da AWS para criar os recursos"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "O nome globalmente único para o bucket S3"
  type        = string
  # ATENÇÃO: Troque este valor!
  default     = "meu-site-estatico-super-unico-12345" 
}