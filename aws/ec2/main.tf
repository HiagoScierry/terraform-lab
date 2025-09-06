# Configura o Terraform e o provedor AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Gerando uma chave SSH para acessar a instância
resource "tls_private_key" "generated_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Salvando a chave pública na AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "generated-key-terraform"
  public_key = tls_private_key.generated_ssh_key.public_key_openssh
}

# Salvando a chave privada localmente
resource "local_file" "private_key_file" {
  content  = tls_private_key.generated_ssh_key.private_key_pem
  filename = "terraform-key.pem" # Nome do arquivo que será salvo no seu computador
  file_permission = "0400" # Permissão de "somente leitura" para o dono
}

# Criando um grupo de segurança para permitir acesso HTTP e SSH
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Permite trafego HTTP e SSH"

  # Regra de entrada para a porta 3000 do APP Node.js de qualquer IP
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regra de entrada para a porta 22 (SSH) de qualquer IP
  # ATENÇÃO: Em produção, restrinja isso para o seu IP.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite acesso SSH de qualquer lugar
  }

  # Regra de saída: permite que a instância acesse a internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Todos os protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

# Obtendo a AMI mais recente do Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (dona do Ubuntu)
}

# Criando a instância EC2
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.web_sg.name]

  user_data = templatefile("${path.module}/user_data.sh", {
    app_code          = file("${path.module}/../../apps/simple_node_api/index.js")
    package_json_code = file("${path.module}/../../apps/simple_node_api/package.json")
  })

  tags = {
    Name = "NodeJS-WebServer"
  }
}