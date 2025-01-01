provider "aws" {
    region = var.region
    
    }


module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami= var.ami
    instance_type =  lookup(var.instance_type, terraform.workspace, "t2.micro")
}