provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

resource "aws_key_pair" "sshpubkey" {
  key_name   = "goto@mc"
  public_key = "${file("${var.keypath}")}"
}
