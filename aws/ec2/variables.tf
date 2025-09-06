variable "aws_region" {
  description = "Região da AWS para criar os recursos."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t2.micro" # Incluído no Free Tier da AWS
}
