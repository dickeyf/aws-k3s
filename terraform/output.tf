output "master_node_ipv6" {
  value = aws_instance.master_node.ipv6_addresses[0]
}

output "worker_nodes_ipv6" {
  value = aws_instance.worker_nodes.*.ipv6_addresses
}