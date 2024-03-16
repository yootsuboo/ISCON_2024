data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "iscon-2024-terraform-state"
    region = "ap-northeast-1"
    key    = "vpc/terraform.tfstate"
  }
}

