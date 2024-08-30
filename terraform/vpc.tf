data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                        = var.vpc_name
    Deployment  = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.vpc_name
    Deployment  = var.vpc_name
  }
}