variable "project" {
  description = "project code which used to compose the resource name"
  default     = ""
}

variable "env" {
  description = "env"
  default     = "test"
}

variable "prefix" {
  description = "prefix"
  default     = "Test-"
}

variable "codepipeline_bucket_name" {
  description = "s3 bucket name for codepipeline artifact"
  default     = "test-codepipeline-artifact"
}

variable "codestar_connections_arn" {
  description = "codestar connections arn for connect bitbucket to aws"
  default     = ""
}

variable "aws_codebuild_source_credential_bitbucket_token" {
  default = {}
}

variable "pipeline" {
  default = {}
}

variable "approval_group_name" {
  default = ""
}