terraform {
  backend "s3" {
    bucket  = "iscon-2024-terraform-state"
    region  = "ap-northeast-1"
    key     = "aws/s3"
    encrypt = true
  }
}

