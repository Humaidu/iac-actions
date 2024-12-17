terraform {
  backend "s3" {
    bucket = "hash-terraform-state-bucket"
    region = "us-east-1"
    key = "iac-actions/terraform.tfstate"
  }
}