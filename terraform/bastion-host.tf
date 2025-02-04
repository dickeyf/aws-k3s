resource "aws_instance" "bastion_host" {
  ami = data.aws_ami.ubuntu_24_04.id
  instance_type = var.bastion_instance_type

  credit_specification {
    cpu_credits = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.bastion_host_eni.id
    device_index         = 0
  }

  key_name = var.keypair_name

  # Inject setup script via cloud-init so that its ready to use after Terraform deployment is completed.
  # Inject any parameters that will be needed by K3S's the deployment here.
  user_data = <<HEREDOC
#!/bin/bash
apt update

# Install Ansible
apt install -y ansible

# Install kubectl & helm
snap install kubectl --classic
snap install helm --classic

# Install Cilium CLI tool - Grab latest stable version
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/$${CILIUM_CLI_VERSION}/cilium-linux-$${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-$${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-$${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-$${CLI_ARCH}.tar.gz{,.sha256sum}

# Ensure that passwordless ssh is setup from bastion host to the cluster's nodes
mkdir -p /home/ubuntu/.ssh
cat << EOF > /home/ubuntu/.ssh/id_rsa
${tls_private_key.generated_key.private_key_openssh}
EOF
chmod 600 /home/ubuntu/.ssh/id_rsa

# Any parameters that are known only during TF deploy are injected here, so the user doesn't have to manually
# copy that inside the bastion host.
cat << EOF > /home/ubuntu/k3s.env
MASTER=${aws_instance.master_node.private_ip}
WORKER1=${aws_instance.worker_nodes[0].private_ip}
WORKER2=${aws_instance.worker_nodes[1].private_ip}
EOF

# Ensure they get loaded as part of environment whenever a user SSH in.
echo "source /home/ubuntu/k3s.env" >> /home/ubuntu/.bashrc

cd /home/ubuntu
git clone https://github.com/k3s-io/k3s-ansible.git

cat << EOF > /home/ubuntu/k3s-ansible/inventory.yml
${local.ansible_inventory}
EOF

cat << EOF > /home/ubuntu/k3s-ansible/cilium-values.yaml
${local.cilium_values}
EOF

# All the files above have to be owned by the ubuntu user
chown ubuntu:ubuntu -R /home/ubuntu

HEREDOC

  root_block_device {
    delete_on_termination = true
    volume_type = "gp3"
    volume_size = 32
  }

  tags = {
    Name = "Bastion Host"
    Deployment  = var.vpc_name
  }
}

resource "aws_network_interface" "bastion_host_eni" {
  subnet_id = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]

  tags = {
    Name = "Bastion Host ENI"
    Deployment  = var.vpc_name
  }
}

resource "aws_eip_association" "bastion_host_eip_assoc" {
  network_interface_id = aws_network_interface.bastion_host_eni.id
  allocation_id = aws_eip.bastion_host_ip.allocation_id
}

resource "aws_eip" "bastion_host_ip" {
  tags = {
    Name = "Bastion Host EIP"
    Deployment  = var.vpc_name
  }
}
