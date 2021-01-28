# As a Devops engineer I want to build a ec2 in a public subnet using only 
# terraform with the tag - Name:Cloudafterdark-test
# I should be able to log into the ec2 instance and test that it is up and running

# The default provider configuration; resources that begin with `aws` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "vpc_25" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true


  tags = {
    Name = "Cloud_25"
  }
}

# create Internet Gateway
resource "aws_internet_gateway" "ig_25" {
  vpc_id = aws_vpc.vpc_25.id
  tags = {
    Name = "Cloud25_igw"
  }
}

# create public subnet
resource "aws_subnet" "public_25" {
  vpc_id                  = aws_vpc.vpc_25.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Cloud_25"
  }
}

#create route table
resource "aws_route_table" "rt_25" {
  vpc_id = aws_vpc.vpc_25.id
  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_25.id
  }
  tags = {
    Name = "cloud_25"
  }
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_25.id
  route_table_id = aws_route_table.rt_25.id
}


#create security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_25.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }

  # all traffic should get to port 22
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # all traffic should get to port 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


#create EC2 instance
resource "aws_instance" "cloud_25" {
  ami                         = "ami-0885b1f6bd170450c"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_25.id
  security_groups             = ["${aws_security_group.allow_tls.id}"]
  associate_public_ip_address = true
  depends_on                  = [aws_internet_gateway.ig_25]
  key_name                    = "************"






  tags = {
    Name = "Cloudafterdark-test"
  }
}






