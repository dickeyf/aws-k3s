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
