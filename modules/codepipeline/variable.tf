variable "prefix" {
  description = "prefix"
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

variable "approval_group_name" {
  default = ""
}