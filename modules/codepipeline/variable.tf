variable "project" {
  description = "project code which used to compose the resource name"
  default     = ""
}

variable "env" {
  description = "environment: dev, stg, qa, prod "
  default     = ""
}

variable "codepipeline_info" {
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

variable "codestar_connections_arn" {
  default = ""
}