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

variable "codebuild_info" {
  default = {}
}

variable "codepipeline_bucket_arn" {
  default = ""
}

variable "codepipeline_bucket_id" {
  default = ""
}

variable "codebuild_source_credential" {
  type = object({
    auth_type = optional(string, "")
    server_type = optional(string, "")
    token = optional(string, "")
    user_name = optional(string, "")
  })
}