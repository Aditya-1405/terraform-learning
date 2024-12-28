This Terraform script provisions an EC2 instance in AWS, configures a VPC with necessary 
components (subnet, Internet Gateway, Route Table, etc.), and deploys a static website on the EC2 instance using Apache.

Intructions:

1. We have created a key for ssh access to ec2 instance and then provided the path for public key to be read.

2. We have created a vpc and a subnet in the vpc along with that we have enabled auto-assign public ip to ensure 
   that subnet gets public ip.

3. Created an IGW and a route table and added a route to direct traffic to IGW.

4. Associated the route table with the subnet, enabling internet access for the subnet.

5. Created a security group with ingress rules for port "22" and "80" and egress rule for all outbound traffic.

6. Created an EC2 instance with specified AMI and instance type and launched it in defined particular subnet. 
   We have used provisioners such as "file" and "remote-exec" to perform certain task inside ec2 instance after connecting to it with connection block.

   6.1 file Provisioner:
       The file provisioner is used to copy files or directories from the local machine to a remote machine. This is useful for deploying configuration files, scripts, or other assets to a provisioned instance.

       Example:
         provisioner "file" {
            source      = "2137_barista_cafe/"
            destination = "/home/ubuntu/"
         }
         
        In this example "file" provisioner copies the files of "2137_barista_cafe" from local machine to "/home/ubuntu/" location in AWS EC2 instance using SSH connection.
    
    6.2 remote-exec Provisioner:
        The remote-exec provisioner is used to run scripts or commands on a remote machine over SSH or WinRM connections. It's often used to configure or install software on provisioned instances.

        Example:
            provisioner "remote-exec" {
                inline = [
                    "sudo apt update -y",
                    "sudo apt-get install apache2 -y",
                    "sudo cp -r /home/ubuntu/* /var/www/html/",
                    "sudo systemctl enable apache2",
                    "sudo systemctl start apache2"
                ]
             }  

        In this example, the remote-exec provisioner connects to the AWS EC2 instance using SSH and runs a series of commands to update the package repositories, install Apache HTTP Server, copies the files in "/home/ubuntu" dir, move them to default apache path "/var/www/html" and start the HTTP server.
    
    6.3 local-exec Provisioner:
        The local-exec provisioner is used to run scripts or commands locally on the machine where Terraform is executed. It is useful for tasks that don't require remote execution, such as initializing a local database or configuring local resources.

        Example:
           resource "null_resource" "example" {
           triggers = {
            always_run = "${timestamp()}"
          }
          
          provisioner "local-exec" {
            command = "echo 'This is a local command'"
           }
          }
        In this example, a null_resource is used with a local-exec provisioner to run a simple local command that echoes a message to the console whenever Terraform is applied or refreshed. The timestamp() function ensures it runs each time.