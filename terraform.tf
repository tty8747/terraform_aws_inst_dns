terraform {
 backend "s3" {
 bucket = "ec00-bucket"
 region = "eu-central-1"
 key = "terraform.tfstate"
 }
}
