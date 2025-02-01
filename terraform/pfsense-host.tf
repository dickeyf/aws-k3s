resource "aws_instance" "pfsense_host" {
  count         = var.enable_pfsense ? 1 : 0
  ami           = data.aws_ami.pfsense.id
  instance_type = var.pfsense_instance_type

  credit_specification {
    cpu_credits = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.pfsense_host_eni[0].id
    device_index         = 0
  }

  source_dest_check = false
  key_name          = var.keypair_name

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
    volume_size           = 32
  }

  tags = {
    Name       = "PfSense Host"
    Deployment = var.vpc_name
  }
}

resource "aws_network_interface" "pfsense_host_eni" {
  count           = var.enable_pfsense ? 1 : 0
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]

  ipv6_address_count = 1
  ipv6_prefix_count  = 1

  source_dest_check = false

  tags = {
    Name       = "PfSense Host ENI"
    Deployment = var.vpc_name
  }
}

resource "aws_eip_association" "pfsense_host_eip_assoc" {
  count                = var.enable_pfsense ? 1 : 0
  network_interface_id = aws_network_interface.pfsense_host_eni[0].id
  allocation_id        = aws_eip.pfsense_host_ip[0].allocation_id
}

resource "aws_eip" "pfsense_host_ip" {
  count = var.enable_pfsense ? 1 : 0
  tags = {
    Name = "pfsense EIP"
    Deployment  = var.vpc_name
  }
}
