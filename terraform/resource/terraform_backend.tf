terraform {
  backend "s3" {
    bucket  = "iscon-2024-terraform-state-resource"
    region  = "ap-northeast-1"
    key     = "resource/terraform.tfstate"
    encrypt = true
  }
}

