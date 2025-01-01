variable "cidr" {
  default = "10.0.0.0/16"
}


variable "subnet" {
  default = "10.0.0.0/24"

}

variable "ami" {
  default = "ami-053b12d3152c0cc71"
}

variable "instance_type" {
  default = "t2.micro"

}

variable "region" {
  default = "ap-south-1"
}

variable "availability_zone" {
  default = "ap-south-1a"
}