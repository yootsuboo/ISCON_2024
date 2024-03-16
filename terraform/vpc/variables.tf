variable "prefix" {
  description = "prefix name"
  default = "iscon-2024"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region = data.aws_region.current.name
}

locals {
  prefix = var.prefix
  common_tags = {
    "Terraform" = "true"
  }
}
