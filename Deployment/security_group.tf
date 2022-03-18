# VPC Module
module "myvpc" {
    source = "./module/network"
    /*
    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
    */
    #in this case even if we left in vpc variables in module AWS_REGION= eu-west-2 as default value, using the
    #previous line it will take the default variable AWS_REGION value of this variables.tf file
}

#Security group for the Instances
resource "aws_security_group" "levelup-instance" {
  vpc_id      = module.myvpc.vpc_id
  name        = "levelup-instance"
  description = "security group for instances"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.levelup-elb-securitygroup.id]
  }

  tags = {
    Name = "levelup-instance"
  }
}