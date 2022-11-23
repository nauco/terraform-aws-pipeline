############################################
# AWS Provider Configuration
############################################
provider "aws" {
  region  = "ap-northeast-2"
}

############################################
# Common Tag Setting
############################################
locals {
  common_tags = merge(var.default_tags,{
    "project" = var.project
    "region"  = var.region
    "env"     = var.env
    "managed" = "terraform"
  })
}
