provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address = "http://65.0.183.77:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "d49015cf-8e3f-f023-9ef9-9353e801e537"
      secret_id = "5cf76e46-13e7-aad8-86d2-42af9de5aaba"
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
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["vault_integration"]
  }
}