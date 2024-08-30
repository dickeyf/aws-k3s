resource "aws_subnet" "public_ipv4_subnet" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]

  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 0)

  tags = {
    Name = "${var.vpc_name}-public"
    Deployment  = var.vpc_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]

  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  ipv6_cidr_block = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 2)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.vpc_name}-private"
    Deployment  = var.vpc_name
  }
}

resource "aws_eip" "nat_ip" {
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_ipv4_subnet.id

  tags = {
    Name = "${var.vpc_name}-public"
    Deployment  = var.vpc_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public"
    Deployment  = var.vpc_name
  }
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_ipv4_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-private"
    Deployment  = var.vpc_name
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}