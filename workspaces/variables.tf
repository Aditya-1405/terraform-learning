variable "region" {
    default = "ap-south-1"
  
}
variable "ami" {
  default = "ami-053b12d3152c0cc71"
}

variable "instance_type" {
    type = map(string)
    default = {
        "dev" = "t2.micro"
        "stage" = "t2.micro"
    }
  
}