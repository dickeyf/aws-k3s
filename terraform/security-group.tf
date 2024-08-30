resource "aws_security_group" "sg" {
  name   = "${var.vpc_name}-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-sg"
    Deployment  = var.vpc_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.sg.id
  from_port         = 22
  ip_protocol       = "TCP"
  to_port           = 22
  cidr_ipv6         = var.allowed_ipv6_cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "from_sg" {
  security_group_id = aws_security_group.sg.id
  ip_protocol       = "-1"
  referenced_security_group_id = aws_security_group.sg.id
}

resource "aws_vpc_security_group_egress_rule" "ipv4_egress" {
  security_group_id = aws_security_group.sg.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "ipv6_egress" {
  security_group_id = aws_security_group.sg.id
  ip_protocol = "-1"
  cidr_ipv6 = "::/0"
}