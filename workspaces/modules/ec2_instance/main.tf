provider "aws" {
    region = var.region
}

variable "ami" {
  default = ""
  description = "The AMI ID for the EC2 instance."
}

variable "region" {
  default = ""
  description = "The AWS region where the EC2 instance will be launched."
}

variable "instance_type" {
  default = ""
  description = "The instance type for the EC2 instance (e.g., t2.micro)."
}

resource "aws_instance" "ws_instance" {
    ami = var.ami
    instance_type = var.instance_type
    tags = {
      Name = "workspace_instance_${terraform.workspace}"
    }
}