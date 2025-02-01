# Overview

Contains the terraform code to create the infrastructure in AWS required to deploy a k3s cluster.

## Deployment costs (US dollar - hourly - us-east-1)

(Cluster)
3x t3.xlarge: 0.167*3 = 0.501
(Bastion host)
1 t3.large: 0.0835
(Networking)
1 t3.medium: 0.0418
1 pfSense license (t3.medium): 0.12
1 NAT GW: 0.045
(Storage)
5x 32GB gp3 volumes: 0.0178

Total hourly cost: 0.8091$
Daily cost: 19.4179$
Monthly cost: 582.54$

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