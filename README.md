# 🚀 Deploy Dynamic Web Application on AWS with Terraform, Docker, Amazon ECR, and ECS

This project demonstrates how to deploy a **containerized dynamic web application** on **Amazon Web Services (AWS)** using **Terraform**, **Docker**, **Amazon Elastic Container Registry (ECR)**, and **Elastic Container Service (ECS with Fargate)** — complete with **HTTPS via ACM** and **custom domain DNS via Route 53**.

---

## 🧰 Tech Stack

* **Terraform** – Infrastructure as Code
* **Docker** – Containerization
* **Amazon ECR** – Container image storage
* **Amazon ECS (Fargate)** – Serverless container orchestration
* **Application Load Balancer (ALB)** – Traffic routing
* **Route 53** – DNS Management
* **AWS Certificate Manager (ACM)** – SSL/TLS certificate provisioning

---

## 📦 Prerequisites

* AWS account with sufficient IAM permissions
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* [Docker](https://docs.docker.com/get-docker/)
* AWS CLI configured (`aws configure`)
* A registered domain name (hosted in **Route 53**)

---

## 🛠️ How It Works

1. **Docker** builds a container image of your app.
2. **Terraform** provisions the infrastructure:

   * VPC, Subnets, Internet Gateway, NAT Gateway
   * Amazon ECR repo and pushes image
   * ECS Cluster + Fargate Task + Service
   * ALB, HTTP + HTTPS Listener
   * DNS via Route 53
   * SSL via ACM
3. **ACM** provides an SSL certificate for your domain.
4. **Route 53** maps your domain to the ALB.
5. **ECS** deploys your containerized app via Fargate.

---

## 🚀 Deployment Steps

### 1. Clone the Repo

```bash
git clone https://github.com/your-username/dynamic-webapp-aws.git
cd dynamic-webapp-aws
```

### 2. Build and Push Docker Image to ECR

```bash
# Authenticate
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com

# Build
docker build -t my-webapp .

# Tag
docker tag my-webapp:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-webapp:latest

# Push
docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-webapp:latest
```

### 3. Update Variables

In `terraform.tfvars` or via CLI, provide:

```hcl
domain_name = "yourdomain.com"
hosted_zone_id = "Zxxxxxxxxxxxxxx"
certificate_arn = "arn:aws:acm:..."
ecr_repo_url = "<aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-webapp"
```

> ⚠️ Make sure your domain is verified in **Route 53**, and the ACM certificate is **in the same region as your ALB**.

### 4. Deploy Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

---

## 🌐 Accessing Your Application

Once deployed:

* Visit your app at `https://yourdomain.com` (with valid SSL certificate)
* Terraform will also output the ALB DNS and other relevant details

---

## 🧼 Cleanup Resources

```bash
terraform destroy
```

---

## ✅ Features

* ✅ Custom domain via Route 53
* ✅ Free HTTPS via AWS ACM
* ✅ Infrastructure as Code with Terraform
* ✅ Containerized Deployment with Docker
* ✅ Serverless ECS Fargate backend
* ✅ Scalable and production-ready foundation


