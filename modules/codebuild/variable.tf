variable "project" {
  description = "project code which used to compose the resource name"
  default     = ""
}

variable "env" {
  description = "environment: dev, stg, qa, prod "
  default     = ""
}

variable "codebuild_info" {
  default = {}
}

variable "codepipeline_bucket_name" {
  default = ""
}

variable "codepipeline_bucket_arn" {
  default = ""
}

variable "codepipeline_bucket_id" {
  default = ""
}


