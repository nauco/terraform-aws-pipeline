variable "project" {
  description = "project code which used to compose the resource name"
  default     = ""
}

variable "env" {
  description = "environment: dev, stg, qa, prod "
  default     = ""
}

variable "key" {
  description = "for naming rule"
  default     = ""
}

variable "stage" {
  default = []
}

variable "stagelist" {
  default = []
}

variable "approval" {
  default = []
}

variable "project_name" {
  default = []
}

variable "common_tags" {
  default = []
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