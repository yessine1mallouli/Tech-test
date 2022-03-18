variable "AWS_ACCESS_KEY" {
    type = string
    default = /* aws acces key */
}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
default = "eu-west-3"
}

variable "AMIS" {
    type = map
    default = {
        #eu-west-3 = "ami-052f10f1c45aa2155"
        eu-west-3 = var.AMI_ID
    }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "../../keys/prac_keypair.pem "
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "../../keys/prac_keypair.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "AMI_ID" {
    type = string 
    default = ""
}