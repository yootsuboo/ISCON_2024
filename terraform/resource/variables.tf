variable "prefix" {
  description = "prefix name"
  default     = "iscon-2024"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

locals {
  prefix = var.prefix
  common_tags = {
    "Terraform" = "true"
  }
}

locals {
  vpc_id                = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_id_1a   = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  public_subnet_id_1c   = data.terraform_remote_state.vpc.outputs.public_subnets[1]
  public_subnet_id_1d   = data.terraform_remote_state.vpc.outputs.public_subnets[2]
  private_subnet_id_1a  = data.terraform_remote_state.vpc.outputs.private_subnets[0]
  private_subnet_id_1c  = data.terraform_remote_state.vpc.outputs.private_subnets[1]
  private_subnet_id_1d  = data.terraform_remote_state.vpc.outputs.private_subnets[2]
  database_subnet_id_1a = data.terraform_remote_state.vpc.outputs.database_subnets[0]
  database_subnet_id_1c = data.terraform_remote_state.vpc.outputs.database_subnets[1]
  database_subnet_id_1d = data.terraform_remote_state.vpc.outputs.database_subnets[2]
}

