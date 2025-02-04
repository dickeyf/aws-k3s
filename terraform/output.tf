output "master_node_ipv6" {
  value = aws_instance.master_node.ipv6_addresses[0]
}

output "worker_nodes_ipv6" {
  value = aws_instance.worker_nodes.*.ipv6_addresses
}

output "service_ipv4_cidr" {
  value = var.service_ipv4_cidr
}

output "pods_ipv4_cidr" {
  value = var.pods_ipv4_cidr
}

output "service_ipv6_cidr" {
  value = cidrsubnet(cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 1), 48, 0)
}

output "pods_ipv6_cidr" {
  value = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 2)
}

output "ssh_private_key" {
  value = tls_private_key.generated_key.private_key_openssh
  sensitive = true
}

output "bastion_ipv6" {
  value = aws_instance.bastion_host.ipv6_addresses[0]
}

output "bastion_ipv4" {
  value = aws_instance.bastion_host.public_ip
}

output "pfsense_ipv4" {
  value = var.enable_pfsense == true ? aws_instance.pfsense_host[0].public_ip : null
}

output "pfsense_ipv6" {
  value = var.enable_pfsense == true ? aws_instance.pfsense_host[0].ipv6_addresses[0] : null
}

output "ssh_config" {
  value = local.ssh_config
}

output "bastion_ssh_cmd" {
  value = "ssh -F .tmp/ssh_config bastion"
}

output "master_ssh_cmd" {
  value = "ssh -F .tmp/ssh_config master"
}

output "worker1_ssh_cmd" {
  value = "ssh -F .tmp/ssh_config worker1"
}

output "worker2_ssh_cmd" {
  value = "ssh -F .tmp/ssh_config worker2"
}
