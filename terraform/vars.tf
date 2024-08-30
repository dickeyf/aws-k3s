variable "aws_region" {
  default = "us-east-1"
  type = string
}

variable "instance_type" {
  default = "t3.xlarge"
  description = "The instance type to use for the k3s nodes.  Default is t3.xlarge, which should be cheap enough, but powerful enough for most testing use cases."
  type = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default = "k3s-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default = "172.31.0.0/16"
}

variable "allowed_ipv6_cidr_block" {
  description = "The allowed IPv6 CIDR blocks.  Default is all IPv6 addresses, but it is suggested that you put your own public ipv6 CIDR block here (From where you'll ssh)."
  type        = string
  default = "::/128"
}
