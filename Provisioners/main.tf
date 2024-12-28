provider "aws" {
  region = var.region
}

#Creating keys for ssh
resource "aws_key_pair" "provisioners_kp" {
  key_name   = "terraform_provisioners_kp"
  public_key = file("C:\\Users\\HP VICTUS\\.ssh\\id_rsa.pub") #replace with your pub key
}

#Creating VPC
resource "aws_vpc" "provisioners_VPC" {
  cidr_block = var.cidr
  tags = {
    Name = "terraform_provisioners_VPC"
  }
}

#Creating a subnet inside VPC
resource "aws_subnet" "provisioner_subnet" {
  vpc_id                  = aws_vpc.provisioners_VPC.id
  cidr_block              = var.subnet
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "terraform_provisioners_subnet"
  }
}

#Creating Internet Gateway for Internet Access
resource "aws_internet_gateway" "provisioner_IGW" {
  vpc_id = aws_vpc.provisioners_VPC.id
  tags = {
    Name = "terraform_provisioners_IGW"
  }
}


#Creating Routes table and associating it with IGW
resource "aws_route_table" "provisioner_RT" {
  vpc_id = aws_vpc.provisioners_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.provisioner_IGW.id
  }
  tags = {
    Name = "terraform_provisioners_RT"
  }
}

#Associating RT with subnet

resource "aws_route_table_association" "provisioner_RTA" {
  subnet_id      = aws_subnet.provisioner_subnet.id
  route_table_id = aws_route_table.provisioner_RT.id

}

#Creating security group for ec2

resource "aws_security_group" "provisioner_SG" {
  vpc_id = aws_vpc.provisioners_VPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing SSH access to ec2"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing internet access to connect to ec2"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing internet access to ec2"
  }

  tags = {
    Name        = "terraform_provisioner_SG"
    Description = "Terraform provisioner security group"
  }

}

#Creating ec2 in our created VPC and copying static website files to it

resource "aws_instance" "provisioner_EC2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.provisioners_kp.id
  subnet_id              = aws_subnet.provisioner_subnet.id
  vpc_security_group_ids = [aws_security_group.provisioner_SG.id]
  tags = {
    Name = "Terraform Provisioner EC2"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:\\Users\\HP VICTUS\\.ssh\\id_rsa") #replace with your pvt key
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "2137_barista_cafe/"
    destination = "/home/ubuntu/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y > /tmp/provision.log 2>&1",
      "sudo apt-get install apache2 -y >> /tmp/provision.log 2>&1",
      "sudo cp -r /home/ubuntu/* /var/www/html/",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2"
    ]
  }
}

output "ip" {
    value = aws_instance.provisioner_EC2.public_ip
}