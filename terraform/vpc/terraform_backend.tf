terraform {
  backend "s3" {
    bucket  = "iscon-2024-terraform-state"
    region  = "ap-northeast-1"
    key     = "vpc/terraform.tfstate"
    encrypt = true
  }
}

