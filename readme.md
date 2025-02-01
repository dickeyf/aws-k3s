# Overview

Contains the terraform code to create the infrastructure in AWS required to deploy a k3s cluster.

## Deployment costs (US dollar - hourly - us-east-1)

| Resources                     | Hourly Cost | Daily Cost   | Monthly Cost |
|-------------------------------|-------------|--------------|--------------|
| Cluster (3x t3.xlarge)        | 0.501$      | 12.024$      | 360.72$      |
| Bastion host (1 t3.large)     | 0.0835$     | 2.004$       | 60.12$       |
| Networking (1 t3.medium)      | 0.0418$     | 1.0032$      | 30.096$      |
| pfSense license (t3.medium)   | 0.12$       | 2.88$        | 86.4$        |
| NAT GW                        | 0.045$      | 1.08$        | 32.4$        |
| Storage (5x 32GB gp3 volumes) | 0.089$      | 2.136$       | 64.08$       |
| **Total**                     | **0.8091$** | **19.4179$** | **582.54$**  |

## Deployment steps

Starts by setting up AWS CLI credentials (If not already done):
```bash
aws configure
```
Then, paste in your AWS ACCESS KEY

```bash
mkdir -p .tmp
terraform output -raw ssh_private_key > .tmp/ssh
chmod .tmp/ssh
ssh -i ./tmp/ssh ubnutu@`terraform output -raw master_node_ipv6`
```

## Terraform docs command

```bash
cd terraform
terraform-docs markdown table --output-file README.md .
```