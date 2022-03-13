#AWS VPC Resource
resource "aws_vpc" "levelupvpc" {
  cidr_block            = var.cidr_vpc
  instance_tenancy = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  enable_classiclink   = false
  
  tags = {
    Environment         = var.ENVIRONMENT
    Name = "vpc-${var.ENVIRONMENT}"
  }
}
# Public Subnets in Custom VPC
resource "aws_subnet" "levelupvpc-public-1" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}a"  

  tags = {
    Name = "vpc-${var.ENVIRONMENT}-public-1"
  }
}

resource "aws_subnet" "levelupvpc-public-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}b"

  tags = {
    Name = "vpc-${var.ENVIRONMENT}-public-2"
  }
}

# Private Subnets in Custom VPC
resource "aws_subnet" "levelupvpc-private-1" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}a" 

  tags = {
    Name = "vpc-${var.ENVIRONMENT}-private-1"
  }
}

resource "aws_subnet" "levelupvpc-private-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}b"

  tags = {
    Name = "vpc-${var.ENVIRONMENT}-private-2"
  }
}

#AWS Internet Gateway
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id        = aws_vpc.levelupvpc.id
  
  tags = {
    Environment = var.ENVIRONMENT
    Name = "levelup-igw"
  }
}

# AWS Route Table
resource "aws_route_table" "levelup_rtb_public" {
  vpc_id            = aws_vpc.levelupvpc.id

  route {
      cidr_block    = "0.0.0.0/0"
      gateway_id    = aws_internet_gateway.levelup_igw.id
  }

  tags = {
    Environment     = var.ENVIRONMENT
    Name = "levelup_rtb_public"
  }
}

# AWS Route Association 
resource "aws_route_table_association" "levelup_rta_subnet_public_1" {
  subnet_id      = aws_subnet.levelupvpc-public-1.id
  route_table_id = aws_route_table.levelup_rtb_public.id
}

resource "aws_route_table_association" "levelup_rta_subnet_public_2" {
  subnet_id      = aws_subnet.levelupvpc-public-2.id
  route_table_id = aws_route_table.levelup_rtb_public.id
}

/*
# AWS Security group
resource "aws_security_group" "levelup_sg_22" {
  name = "levelup_sg_22"
  vpc_id = aws_vpc.levelup_vpc.id

  # SSH access from the VPC
  ingress {
      from_port     = 22
      to_port       = 22
      protocol      = "tcp"
      cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Environment     = var.ENVIRONMENT
  }
}*/