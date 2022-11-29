variable "project" {
  description = "project code which used to compose the resource name"
  default     = ""
}

variable "env" {
  description = "environment: dev, stg, qa, prod "
  default     = ""
}

variable "region" {
  description = "aws region to build network infrastructure"
  default     = ""
}

variable "codepipeline_bucket_name" {
  description = "s3 bucket name for codepipeline artifact"
  default     = ""
}

variable "pipeline" {
  default = {}
}

variable "approval_group_name" {
  default = ""
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
