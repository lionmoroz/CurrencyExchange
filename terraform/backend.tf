terraform {
  backend "s3" {
    bucket = "terraform-state-aws-tes"
    key = "global/s3/terraform.tfstate"
    region = "eu-north-1"
  }
}