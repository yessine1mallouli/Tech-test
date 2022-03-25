# Variables
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "AWS_REGION" {
    type    = string
    default = "eu-west-3"
}
/*
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.1.0.0/24"
}*/
/*
variable "availability_zone" {
  type = List
  description = "availability zones to create subnets"
  default = ["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"]
}
*/

variable "public_key_path" {
  description = "Public key path"
  default = "../../../keys/prac_keypair.pub"
}

variable "ENVIRONMENT" {
  description = "Environment tag"
  default = "Development"
}
