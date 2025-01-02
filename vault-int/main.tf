provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address = "<>:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "<>"
      secret_id = "<>"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "secret-mang-vault-int" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-053b12d3152c0cc71"
  instance_type = "t2.micro"

  tags = {
    Name = "vault-init-terraform-sm"
    Secret = data.vault_kv_secret_v2.example.data["vault_integration"]
  }
}