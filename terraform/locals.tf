locals {
  ansible_inventory = <<HEREDOC
---
k3s_cluster:
  children:
    server:
      hosts:
        ${aws_instance.master_node.private_ip}:
    agent:
      hosts:
        ${aws_instance.worker_nodes[0].private_ip}:
        ${aws_instance.worker_nodes[1].private_ip}:

  # Required Vars
  vars:
    ansible_port: 22
    ansible_user: ubuntu
    k3s_version: ${var.k3s_version}
    cluster_context: k3s-ansible
    kubeconfig: ~/.kube/config
    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"

    server_config_yaml:  |
      write-kubeconfig-mode: "0644"
      flannel-backend: none
      disable-network-policy: true
      disable-kube-proxy: true
      disable-cloud-controller: true
      disable:
        - servicelb
      cluster-cidr: ${var.pods_ipv4_cidr},${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 2)}
      service-cidr: ${var.service_ipv4_cidr},${cidrsubnet(cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 3), 48, 0)}
      cluster-init: true
      tls-san:
        - "${aws_instance.master_node.ipv6_addresses[0]}"
HEREDOC

  cilium_values = <<EOF
operator:
  replicas: 1
kubeProxyReplacement: true
k8sServiceHost: "${aws_instance.master_node.ipv6_addresses[0]}"
k8sServicePort: 6443
envoy:
  enabled: false
bgpControlPlane:
  enabled: true
ipv4:
  enabled: true
ipv6:
  enabled: true
enableIPv4Masquerade: ${var.enable_pfsense}
enableIPv6Masquerade: ${var.enable_pfsense}
EOF

  ssh_config = <<EOF
Host bastion
  Hostname ${aws_instance.bastion_host.public_ip}
  User ubuntu
  IdentityFile .tmp/ssh

Host master
  Hostname ${aws_instance.master_node.private_ip}
  User ubuntu
  IdentityFile .tmp/ssh
  ProxyJump bastion
Host worker1
  Hostname ${aws_instance.worker_nodes[0].private_ip}
  User ubuntu
  IdentityFile .tmp/ssh
  ProxyJump bastion
host worker2
  Hostname ${aws_instance.worker_nodes[1].private_ip}
  User ubuntu
  IdentityFile .tmp/ssh
  ProxyJump bastion
EOF

}
