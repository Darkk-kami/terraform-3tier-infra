# 3-Tier Multi-Region High Availability Infrastructure

## Overview
This project demonstrates the deployment of a 3-tier multi-region high availability infrastructure on AWS using Terraform. The infrastructure is designed to ensure scalability, fault tolerance, and secure application hosting.

![infra](https://github.com/user-attachments/assets/aac1b3af-ab8e-4159-a2e6-0ae5e27df6f1)

## Features
### Architecture
- **Frontend Layer**:
  - Auto Scaling Group (ASG) for high availability.
  - Elastic Load Balancer (ALB) with SSL and custom domain.
- **Application Layer**:
  - EC2 instances in private subnets.
  - NAT Gateway for secure outbound access.
  - Access to AWS Secrets Manager and S3 for application needs.
- **Database Layer**:
  - Amazon RDS in private subnets.
  - Read replica in a secondary region for redundancy and performance.

### Networking and Security
- Custom VPC with public, private, and database subnets across multiple AZs.
- S3 VPC endpoint for private communication.
- Strict security group rules for controlled access.

### High Availability and Monitoring
- Cross-region read replica and VPC peering for failover.
- CloudWatch alarms and Route 53 health checks for automated DNS failover.
- S3 replication and lifecycle policies for disaster recovery.

## Best Practices Implemented
- **Modular Design**: Reusable modules for VPC, ALB, EC2, RDS, and more.
- **Secure Configurations**: Resources deployed in private subnets with strict access control.
- **State Management**: Remote backend state storage in S3 for consistency.
