module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "${local.prefix}-vpc"
  cidr = "192.168.0.0/16"

  azs              = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets  = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  public_subnets   = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  database_subnets = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]

  enable_nat_gateway                 = false
  single_nat_gateway                 = true
  enable_vpn_gateway                 = false
  map_public_ip_on_launch            = true
  create_database_subnet_group       = false
  create_database_subnet_route_table = true

  public_subnet_names = [
    "${local.prefix}-public-subnet-1a",
    "${local.prefix}-public-subnet-1c",
    "${local.prefix}-public-subnet-1d",
  ]
  private_subnet_names = [
    "${local.prefix}-private-subnet-1a",
    "${local.prefix}-private-subnet-1c",
    "${local.prefix}-private-subnet-1d",
  ]
  database_subnet_names = [
    "${local.prefix}-database-subnet-1a",
    "${local.prefix}-database-subnet-1c",
    "${local.prefix}-database-subnet-1d",
  ]
}

