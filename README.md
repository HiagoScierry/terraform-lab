# Terraform on AWS Study Lab

This repository serves as a personal lab for learning and experimenting with [Terraform](https://www.terraform.io/) concepts applied to [Amazon Web Services (AWS)](https://aws.amazon.com/). The goal is to create reproducible and versionable Infrastructure as Code (IaC).

## 🎯 Objective

The main focus of this lab is to practically understand how to provision and manage different AWS services using Terraform's declarative syntax, covering everything from basic compute resources to serverless architectures.

---

## 📂 Included Projects

This repository is divided into directories, each containing an independent Terraform project focused on a specific service or concept.

### 1\. `ec2`

This project provisions an EC2 instance (t2.micro to stay within the Free Tier) and pre-configures it with a startup script (`user_data`).

- **Resources created:**

  - An EC2 instance with Amazon Linux 2.
  - A Security Group that allows traffic on ports 80 (HTTP) and 22 (SSH).
  - A startup script that installs a simple Apache web server.

- **What this project teaches:**

  - Provisioning virtual machines.
  - Configuring firewall rules with Security Groups.
  - Running automation scripts on instance startup.
  - Using variables to customize the infrastructure (e.g., `instance_type`).

> **Note:** A domain setup with Route53 and an SSL certificate was not included to avoid unnecessary costs in a study environment.

### 2\. `lambda_simple_upload`

Demonstrates the simplest way to provision an AWS Lambda function, where the source code is packaged in a local `.zip` file.

- **Resources created:**

  - An AWS Lambda function.
  - An IAM role with the minimum necessary permissions for the Lambda to execute.

- **What this project teaches:**

  - Provisioning serverless resources.
  - Managing permissions with IAM (Identity and Access Management).
  - The deployment lifecycle of a simple Lambda function.

### 3\. `lambda_with_s3_source`

A more advanced example that is closer to a production environment. The function's code is first uploaded to an S3 bucket and then referenced by the Lambda.

- **Resources created:**

  - An S3 bucket to store the source code.
  - An S3 object (the function's `.zip` file).
  - An AWS Lambda function that uses the S3 object as its code source.
  - An IAM role.

- **What this project teaches:**

  - Provisioning object storage with S3.
  - Decoupling the function's code from its infrastructure.
  - How to handle larger deployment packages, as direct uploads have size limitations.

### 4\.`s3_static_website`

This project provides infrastructure as code to deploy a static website using Amazon S3. It automates the creation and configuration of an S3 bucket to host static files, sets up appropriate permissions, and optionally configures static website hosting features such as custom error and index documents.

- **Resources created:**

    - Creates and configures an S3 bucket for static website hosting.
    - Enables public access to static filesvia the S3 website endpoint.
    - Allows you to specify custom index and error documents for your site.
    - Applies a bucket policy to permit public read access to website content.
    - Can be enhanced to support Route 53 and ACM for custom domains and HTTPS.

- **What this project teaches:**

    - Setting up object storage with S3 and configuring it for static website hosting.
    - Applying bucket policies to control access to S3 content.
    - How to extend basic setups with additional AWS services (e.g., Route 53, ACM) for production scenarios.

---

## 🚀 How to Use

### Prerequisites

Before you begin, ensure you have the following tools installed and configured:

1.  **Terraform CLI:** [Installation instructions](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2.  **AWS CLI:** [Installation instructions](https://aws.amazon.com/cli/)
3.  **AWS Credentials:** Your credentials must be configured so that Terraform can authenticate with your account. The most common way is through the `aws configure` command.

### Running the Projects

Each project is self-contained. To run one, follow the steps below inside the project's directory (e.g., `cd ec2/`):

1.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

2.  **Plan the changes:** (Optional, but recommended to see what will be created)

    ```bash
    terraform plan
    ```

3.  **Apply the changes:**

    ```bash
    terraform apply
    ```

    Type `yes` when prompted to confirm the creation of the resources.

### 🧹 Cleaning Up Resources

**Important:** To avoid unexpected costs, always destroy the infrastructure after you have finished your studies.

1.  **Destroy the resources:**
    ```bash
    terraform destroy
    ```
    Type `yes` when prompted to confirm the deletion.

---

## ⚠️ Cost Warning

Running this code will create real resources in your AWS account that **may incur costs**. Although most of the selected resources fall under the AWS Free Tier, usage beyond the limits can result in charges. Always run `terraform destroy` when you are no longer using the infrastructure.

## License

Distributed under the MIT License. See `LICENSE` for more information.
