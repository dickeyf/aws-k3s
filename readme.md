# Overview

Contains the terraform code to create the infrastructure in AWS required to deploy a k3s cluster.

## Deployment steps

Starts by setting up AWS CLI credentials (If not already done):
```bash
aws configure
```
Then, paste in your AWS ACCESS KEY

```bash
terraform output -raw ssh_private_key > .tmp/ssh
chmod .tmp/ssh
ssh -i ./tmp/ssh ubnutu@`terraform output -raw master_node_ipv6`
```

## Terraform docs command

```bash
cd terraform
terraform-docs markdown table --output-file README.md .
```