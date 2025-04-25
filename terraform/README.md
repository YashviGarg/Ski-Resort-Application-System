# Skier Analytics - Infrastructure as Code

This directory contains the Terraform configuration for deploying the Skier Analytics API infrastructure on AWS.

## Infrastructure Overview

The Terraform configuration creates the following resources:

1. **Networking**
   - VPC with public and private subnets across 2 availability zones
   - Internet Gateway for public internet access
   - Route tables for traffic management

2. **Security**
   - Security group for the application with appropriate rules
   - Network ACLs for subnet-level security

3. **Database**
   - DynamoDB table for skier data with Global Secondary Indexes
   - Optimized for the three API query patterns

4. **Monitoring**
   - CloudWatch dashboard for visualizing metrics
   - CloudWatch alarms for critical thresholds
   - SNS topic for alarm notifications

## Prerequisites

- AWS CLI installed and configured
- Terraform v1.0+ installed
- Basic understanding of AWS services and Terraform

## Getting Started

1. **Initialize Terraform**
   ```
   terraform init
   ```

2. **Review the Plan**
   ```
   terraform plan
   ```

3. **Apply the Configuration**
   ```
   terraform apply
   ```

4. **Destroy Resources (when needed)**
   ```
   terraform destroy
   ```

## Configuration

All variables can be customized in `variables.tf` or by creating a `terraform.tfvars` file:

```hcl
aws_region = "us-west-2"
environment = "dev"
project_name = "skier-analytics"
vpc_cidr_block = "10.0.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b"]
```

## Architecture Diagram

```
┌─────────────────────────────────────────┐
│                AWS Cloud                 │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │               VPC               │    │
│  │                                 │    │
│  │  ┌───────────┐   ┌───────────┐  │    │
│  │  │  Public   │   │  Private  │  │    │
│  │  │  Subnet   │   │  Subnet   │  │    │
│  │  └───────────┘   └───────────┘  │    │
│  │                                 │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────┐      ┌─────────────┐   │
│  │  DynamoDB   │      │ CloudWatch  │   │
│  │   Table     │      │ Monitoring  │   │
│  └─────────────┘      └─────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

## Next Steps

For a more complete infrastructure setup, consider adding:

1. **Application Deployment**
   - EC2 instances or ECS containers for the Java application
   - Auto Scaling Group for dynamic capacity

2. **Data Layer Enhancement**
   - Redis caching with ElastiCache
   - DynamoDB Accelerator (DAX) for improved performance

3. **API Management**
   - API Gateway for request management
   - Custom domain and TLS certificates

4. **CI/CD Pipeline**
   - CodePipeline for automated deployments
   - CloudFormation for infrastructure updates

## Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
