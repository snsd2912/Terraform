# this block is required for authentication
# Reference: http://registry.terraform.io/providers/hashicorp/aws/latest/docs

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

# create vpc
resource "aws_vpc" "sanglv_vpc" {
  cidr_block = var.vpc_cidr
}

# create subnet
resource "aws_subnet" "sanglv_public_subnet" {
  vpc_id     = aws_vpc.sanglv_vpc.id
  cidr_block = var.subnet_cidr
  availability_zone = "us-east-1a"
}

# create internet gateway
resource "aws_internet_gateway" "sanglv_gw" {
  vpc_id = aws_vpc.sanglv_vpc.id
}

# update route table to route traffic to from subnet to internet gateway
# Note: target to local is set by default
resource "aws_route_table" "sanglv_route_table" {
  vpc_id = aws_vpc.sanglv_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sanglv_gw.id
  }
}

# assign route table to subnet
resource "aws_route_table_association" "sanglv-rta" {
  subnet_id      = aws_subnet.sanglv_public_subnet.id
  route_table_id = aws_route_table.sanglv_route_table.id
}

# create instance in created public subnet
resource "aws_instance" "sanglv6-HelloWorld" {
  ami           = "ami-052efd3df9dad4825"
  subnet_id     = aws_subnet.sanglv_public_subnet.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

# output will be printed in console when running terraform apply command
output "ec2_ip" {
    # private_ip is a attribute of created ec2 instance
    value = aws_instance.sanglv6-HelloWorld.private_ip
}

# create an elastic ip
resource "aws_eip" "sanglv6-eip" {
  vpc = true
}

output "eip_public_ip" {
  value = aws_eip.sanglv6-eip.public_ip
}

# assign elastic ip to ec2
resource "aws_eip_association" "sanglv6-eip-association" {
  instance_id   = aws_instance.sanglv6-HelloWorld.id
  allocation_id = aws_eip.sanglv6-eip.id
}

# create security group
# resource "aws_security_group" "sanglv_sg" {
#   name        = "sanglv_sg"
#   description = "Allow TLS inbound traffic"

#   ingress {
#     description      = "TLS from VPC"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = [var.vpn_ip]
#   }
# }

