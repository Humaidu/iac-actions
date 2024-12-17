terraform {
  backend "s3" {
    bucket = "hash-terraform-state-bucket-04"
    region = "us-east-1"
    key = "iac-actions/terraform.tfstate"
  }
}