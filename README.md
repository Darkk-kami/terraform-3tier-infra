# Build a Scalable Web Application with Auto Scaling on AWS
![asg](https://github.com/user-attachments/assets/c46385cb-050c-4e40-9103-89be07ce6fdf)

## Overview

This project demonstrates how to build a scalable web application using AWS EC2 instances, an Elastic Load Balancer (ELB), and Auto Scaling. The infrastructure automatically scales based on traffic, ensuring high availability and reliability for the application. This guide applies Terraform best practices, including using modules, managing remote state, and adhering to DRY principles.

## Key Concepts

- **EC2 Instances**: Launch EC2 instances to run the web application.
- **Elastic Load Balancer (ELB)**: Distribute incoming traffic across multiple EC2 instances.
- **Auto Scaling**: Automatically adjust the number of EC2 instances based on demand.

## Infrastructure Setup

1. **EC2 Instances**: Create EC2 instances running web applications and configure security groups to allow only HTTP traffic from ALB
2. **Elastic Load Balancer (ELB)**: Set up an ELB to distribute incoming traffic between EC2 instances.
3. **Auto Scaling Group (ASG)**: Create an Auto Scaling group to manage the scaling of EC2 instances based on metrics like CPU utilization.
4. **CloudWatch Monitoring (Optional)**: Use CloudWatch to monitor performance and trigger Auto Scaling actions when necessary.

## Variables

### `terraform.tfvars`

Define the necessary values in the `terraform.tfvars` file to customize the infrastructure.
