# Laboratório de Estudos Terraform na AWS

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)

Este repositório serve como um laboratório pessoal para aprender e experimentar os conceitos do [Terraform](https://www.terraform.io/) aplicados à [Amazon Web Services (AWS)](https://aws.amazon.com/). O objetivo é criar infraestruturas como código (IaC) de forma reprodutível e versionável.

## 🎯 Objetivo

O foco principal deste laboratório é entender na prática como provisionar e gerenciar diferentes serviços da AWS utilizando a sintaxe declarativa do Terraform, cobrindo desde recursos de computação básicos até arquiteturas serverless.

---

## 📂 Projetos Inclusos

Este repositório está dividido em diretórios, cada um contendo um projeto Terraform independente e focado em um serviço ou conceito específico.

### 1. `ec2`
Este projeto provisiona uma instância EC2 (t2.micro para manter-se no Free Tier) e a pré-configura com um script de inicialização (`user_data`).

* **Recursos criados:**
    * Uma instância EC2 com Amazon Linux 2.
    * Um Security Group que libera as portas 80 (HTTP) e 22 (SSH).
    * Um script de inicialização que instala um servidor web Apache simples.

* **O que este projeto ensina:**
    * Provisionamento de máquinas virtuais.
    * Configuração de regras de firewall com Security Groups.
    * Execução de scripts de automação na inicialização da instância.
    * Uso de variáveis para customizar a infraestrutura (ex: `instance_type`).

> **Nota:** A configuração de um domínio com Route53 e certificado SSL não foi incluída para evitar custos desnecessários em um ambiente de estudo.

### 2. `lambda_with_s3_upload`
Demonstra a forma mais simples de provisionar uma função AWS Lambda, onde o código-fonte é empacotado em um arquivo `.zip` local.

* **Recursos criados:**
    * Uma função AWS Lambda.
    * Uma role do IAM com as permissões mínimas necessárias para a Lambda executar.

* **O que este projeto ensina:**
    * Provisionamento de recursos serverless.
    * Gerenciamento de permissões com IAM (Identity and Access Management).
    * O ciclo de vida de deployment de uma função Lambda simples.

### 3. `lambda_with_s3_upload`
Um exemplo mais avançado e mais próximo de um ambiente de produção. O código da função é primeiro enviado para um bucket S3 e depois referenciado pela Lambda.

* **Recursos criados:**
    * Um bucket S3 para armazenar o código-fonte.
    * Um objeto S3 (o arquivo `.zip` da função).
    * Uma função AWS Lambda que utiliza o objeto do S3 como fonte de seu código.
    * Uma role do IAM.

* **O que este projeto ensina:**
    * Provisionamento de armazenamento de objetos com S3.
    * Desacoplamento do código e da infraestrutura da função.
    * Como lidar com pacotes de deployment maiores, uma vez que o upload direto tem limitações de tamanho.

---

## 🚀 Como Usar

### Pré-requisitos
Antes de começar, garanta que você tenha as seguintes ferramentas instaladas e configuradas:

1.  **Terraform CLI:** [Instruções de instalação](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2.  **AWS CLI:** [Instruções de instalação](https://aws.amazon.com/cli/)
3.  **Credenciais da AWS:** Suas credenciais devem estar configuradas para que o Terraform possa autenticar com sua conta. A forma mais comum é através do comando `aws configure`.

### Executando os Projetos
Cada projeto é autônomo. Para executar, siga os passos abaixo dentro do diretório de cada projeto (ex: `cd ec2/`):

1.  **Inicializar o Terraform:**
    ```bash
    terraform init
    ```

2.  **Planejar as mudanças:** (Passo opcional, mas recomendado para ver o que será criado)
    ```bash
    terraform plan
    ```

3.  **Aplicar as mudanças:**
    ```bash
    terraform apply
    ```
    Digite `yes` quando solicitado para confirmar a criação dos recursos.

### 🧹 Limpando os Recursos
**Importante:** Para evitar custos inesperados, sempre destrua a infraestrutura após concluir seus estudos.

1.  **Destruir os recursos:**
    ```bash
    terraform destroy
    ```
    Digite `yes` quando solicitado para confirmar a exclusão.

---

## ⚠️ Aviso sobre Custos
A execução deste código criará recursos reais na sua conta AWS que **podem gerar custos**. Embora a maioria dos recursos selecionados se enquadre no Free Tier da AWS, o uso fora dos limites pode resultar em cobranças. Sempre execute `terraform destroy` quando não estiver mais usando a infraestrutura.

##  licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.