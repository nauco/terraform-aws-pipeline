############################################
# AWS Provider Configuration
############################################
provider "aws" {
  region  = "ap-northeast-2"

  default_tags {
    tags = var.common_tags
  }
}
