# Financial EKS Platform (AWS DevOps Project)

## Overview

This project provisions a production-style AWS infrastructure using Terraform and deploys a Kubernetes (EKS) cluster with a managed node group. CI/CD automation is designed using GitHub Actions with secure OIDC authentication (no AWS credentials stored in GitHub).

The project demonstrates real-world DevOps practices including infrastructure provisioning, Kubernetes deployment, CI/CD automation, and troubleshooting AWS networking issues.

---

## Architecture

- AWS VPC (Public Subnets)
- Internet Gateway (Public Access)
- Amazon EKS Cluster
- Managed Node Group (t3.micro)
- Kubernetes Service (LoadBalancer type)
- IAM Roles for EKS Cluster & Nodes
- GitHub Actions CI/CD (OIDC-based authentication)

---

##  Tech Stack

- Terraform (Infrastructure as Code)
- AWS (EKS, VPC, IAM, EC2, ELB)
- Kubernetes
- GitHub Actions (CI/CD)
- AWS CLI (Debugging & Operations)
- Docker (optional workloads)

---

##  Security Design

- No hardcoded AWS credentials in CI/CD
- GitHub OIDC federation (token.actions.githubusercontent.com)
- IAM Role-based access for deployments
- Least privilege IAM policies

---

## Deployment Workflow

1. Terraform provisions AWS infrastructure
2. EKS cluster is created with managed node group
3. GitHub Actions pipeline authenticates via OIDC
4. CI/CD deploys Kubernetes workloads to EKS
5. LoadBalancer exposes application publicly

---

## Project Structure

financial-eks-platform/
│
├── terraform/ # Infrastructure as Code (VPC + EKS)
├── github-actions/ # CI/CD workflows (OIDC pipeline)
├── k8s-manifests/ # Kubernetes deployment files
├── README.md # Project documentation


---

# Troubleshooting and Lessons Learned

---

## EKS Node Group Creation Failure

### Issue

CREATE_FAILED
Could not launch On-Demand Instances.
InvalidParameterCombination - Instance type not eligible for Free Tier


### Root Cause

The node group was configured with an instance type that was not eligible under AWS Free Tier constraints.

### Resolution

Validated failure using AWS CLI:

```bash
aws eks describe-nodegroup \
  --cluster-name financial-platform-eks \
  --nodegroup-name financial-platform-node-group \
  --region eu-west-2
Updated Terraform configuration to use a compatible instance type (t3.micro) for cost control and free-tier alignment.

Terraform Destroy Failure (VPC Dependencies)
Issue
DependencyViolation:
The VPC has dependencies and cannot be deleted.
Root Cause

Remaining AWS resources were still attached:

Elastic Network Interfaces (ENIs)
Load Balancer attachments
Kubernetes-managed networking components
Investigation
aws ec2 describe-network-interfaces \
  --filters Name=vpc-id,Values=<vpc-id>

Found AWS-managed ENIs:

RequesterManaged: true
RequesterId: amazon-elb
Kubernetes Load Balancer Cleanup
Issue

A Kubernetes Service of type LoadBalancer created an AWS Classic Load Balancer that remained after cluster deletion.

Investigation
aws elbv2 describe-load-balancers
aws elb describe-load-balancers

Identified Classic Load Balancer:

a228ffc772c3d41f79f75dade0e27161
Resolution

Manually deleted the load balancer:

aws elb delete-load-balancer \
  --load-balancer-name a228ffc772c3d41f79f75dade0e27161

Cleaned remaining security groups and ENIs.

Terraform Backend Issue
Issue

S3 backend initialization failed due to region mismatch.

Resolution
terraform init -reconfigure

Ensured correct backend region alignment.

GitHub Large File Push Issue
Issue

Push failed due to a 685MB Terraform provider binary exceeding GitHub’s 100MB limit.

Resolution
Removed .terraform from Git history
Cleaned repository using git filter-branch
Added proper .gitignore
Re-pushed clean repository
## Key Skills Demonstrated

AWS EKS troubleshooting and debugging
Terraform infrastructure lifecycle management
Kubernetes workload debugging
AWS CLI-based incident investigation
VPC networking and dependency resolution
CI/CD design using GitHub Actions
Secure authentication using OIDC federation
Real-world DevOps problem solving

## Outcome
Fully deployed AWS EKS cluster
Automated infrastructure provisioning with Terraform
Secure CI/CD pipeline design (no static credentials)
Production-style cloud architecture
Clean and reusable DevOps repository

## Author

Teajo99

DevOps / Cloud Engineering Project
