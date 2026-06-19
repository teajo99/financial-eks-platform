# Financial EKS Platform (AWS DevOps Project)

## 🚀 Overview
This project provisions a production-grade AWS EKS Kubernetes cluster using Terraform and deploys applications via GitHub Actions CI/CD with OIDC authentication.

---

## 🏗️ Architecture
- AWS VPC (Public Subnets)
- Internet Gateway 
- Amazon EKS Cluster
- Managed Node Group (t3.micro)
- GitHub Actions CI/CD Pipeline
- IAM OIDC Authentication (no static credentials)

---

## ⚙️ Tech Stack
- Terraform
- AWS (EKS, VPC, IAM, EC2)
- Kubernetes
- GitHub Actions
- Docker (optional app layer)

---

## 🔐 Security
- No AWS access keys used in CI/CD
- GitHub OIDC role-based authentication
- Least privilege IAM roles

---

## 🚀 Deployment Flow
1. Terraform provisions infrastructure
2. GitHub Actions triggers pipeline
3. EKS cluster updated automatically
4. Applications deployed via kubectl / manifests

---

## 📦 Folder Structure
- terraform/ → Infrastructure as Code
- github-actions/ → CI/CD workflows
- k8s-manifests/ → Kubernetes deployments

---

🚧 Challenges Faced & Solutions
1. Large Terraform Provider File (GitHub 100MB Limit)

Problem:
Terraform .terraform directory accidentally got committed, including a 685MB AWS provider binary. This caused GitHub push failures.

Solution:

Removed Terraform cache from Git history
Used git filter-branch and history cleanup
Rebuilt repository cleanly and enforced .gitignore
2. AWS VPC Dependency Errors During Terraform Destroy

Problem:
Internet Gateway and Subnets could not be deleted due to:

attached ENIs
public IP mappings
ELB-managed network interfaces

Solution:

Identified dependencies using aws ec2 describe-network-interfaces
Detached/remapped resources
Ensured NAT Gateway and ENIs were removed before VPC deletion
3. Kubernetes / EKS Resource Cleanup Issues

Problem:
EKS cluster deletion was blocked due to:

LoadBalancer ENIs still attached
Kubernetes services still provisioning AWS resources

Solution:

Deleted Kubernetes workloads first
Cleaned up services before infrastructure teardown
Allowed AWS to release ENIs automatically
4. Terraform Backend Initialization Issues (S3 State)

Problem:
Terraform failed due to:

S3 bucket region mismatch
backend reconfiguration required

Solution:

Ran terraform init -reconfigure
Ensured correct region alignment (eu-west-2)
5. GitHub Actions Authentication (Security Setup)

Problem:
Needed secure deployment without exposing AWS credentials.

Solution:

Configured GitHub OIDC provider (token.actions.githubusercontent.com)
Created IAM role with trust policy for GitHub repository
Enabled secure CI/CD without static AWS keys
💡 Key Learning Outcome

This project demonstrated real-world AWS DevOps challenges including:

Infrastructure dependency management
Secure CI/CD design using OIDC
Terraform state and lifecycle control
Kubernetes + AWS integration troubleshooting
Git history and repository hygiene







## 👨‍💻 Author
Teajo99
