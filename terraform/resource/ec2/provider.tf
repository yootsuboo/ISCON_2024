provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  region = "ap-northeast-3"
  alias  = "osaka"
  default_tags {
    tags = local.common_tags
  }
}

