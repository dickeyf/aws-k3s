resource "aws_instance" "worker_nodes" {
  count = var.worker_node_num

  ami = data.aws_ami.ubuntu_24_04.id
  instance_type = var.instance_type

  credit_specification {
    cpu_credits = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.worker_eni[count.index].id
    device_index         = 0
  }

  key_name = var.keypair_name

  root_block_device {
    delete_on_termination = true
    volume_type = "gp3"
    volume_size = 32
  }

  tags = {
    Name = "Worker Node ${count.index}"
    Deployment  = var.vpc_name
  }
}

resource "aws_network_interface" "worker_eni" {
  count = var.worker_node_num

  subnet_id = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.sg.id]

  tags = {
    Name = "WorkerNode ENI ${count.index}"
    Deployment  = var.vpc_name
  }
}
