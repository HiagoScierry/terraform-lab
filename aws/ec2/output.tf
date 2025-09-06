output "public_ip" {
  description = "Endereço IP público da instância EC2."
  value       = aws_instance.web_server.public_ip
}

output "public_dns" {
  description = "DNS público da instância EC2."
  value       = aws_instance.web_server.public_dns
}